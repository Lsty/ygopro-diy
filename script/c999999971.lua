--传说之骑士 卫宫士郎
function c999999971.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsCode,999999987),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
    --search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c999999971.scon)
	e1:SetTarget(c999999971.stg)
	e1:SetOperation(c999999971.sop)
	c:RegisterEffect(e1)
	--copy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c999999971.coptg)
	e2:SetOperation(c999999971.copop)
	c:RegisterEffect(e2)
	--add code
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EFFECT_ADD_CODE)
	e3:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e3:SetValue(999999987)
	c:RegisterEffect(e3)
end
function c999999971.scon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c999999971.jsfilter(c)
	return c:GetCode()==999999982  and c:IsAbleToHand()
end
function c999999971.stg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c999999971.jsfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c999999971.sop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c999999971.jsfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
end
function c999999971.sfilter(c)
	return  c:IsType(TYPE_EQUIP) and  c:IsFaceup() 
end
function c999999971.tgfilter(c)
	return c:IsType(TYPE_EQUIP) 
end
function c999999971.coptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(c999999971.tgfilter,tp,0x38,0x38,1,nil) 
	and Duel.IsExistingTarget(c999999971.tgfilter,tp,0x3b,0,1,nil) 
    and	Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g1=Duel.SelectTarget(tp,c999999971.sfilter,tp,0x38,0x38,1,1,nil) 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g2=Duel.SelectTarget(tp,c999999971.tgfilter,tp,0x3b,0,1,1,g1:GetFirst())
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g2:GetFirst(),1,0,0)
     e:SetLabelObject(g1:GetFirst()) 
end
function c999999971.copop(e,tp,eg,ep,ev,re,r,rp)
	local tc1,tc2=Duel.GetFirstTarget()
	 if tc1~=e:GetLabelObject() then tc1,tc2=tc2,tc1 end
	    tc2:ResetEffect(tc2:GetOriginalCode(),RESET_CARD)
		tc2:CopyEffect(tc1:GetOriginalCode(),nil)
	    local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(tc1:GetOriginalCode())
		e1:SetReset(RESET_EVENT+0xfe0000)
		tc2:RegisterEffect(e1)
		Duel.Equip(tp,tc2,e:GetHandler()) 
	    local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLED)
		e2:SetCode(EVENT_LEAVE_FIELD) 
		e2:SetOperation(c999999971.resop)
		tc2:RegisterEffect(e2)
end
function c999999971.resop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:ResetEffect(c:GetOriginalCode(),RESET_CARD)
	c:CopyEffect(c:GetOriginalCode(),nil) 
	e:Reset()
end