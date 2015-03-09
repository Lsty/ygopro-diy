--传说之骑士 美杜莎
function c999999964.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),aux.NonTuner(c999999964.synfilter),1)
	c:EnableReviveLimit()
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c999999964.secon)
	e1:SetTarget(c999999964.setg)
	e1:SetOperation(c999999964.seop)
	c:RegisterEffect(e1)
    --pos
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(999999,14))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetHintTiming(0,0x1c0)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,999999964+EFFECT_COUNT_CODE_OATH)
	e2:SetCost(c999999964.poscost)
	e2:SetTarget(c999999964.postg)
	e2:SetOperation(c999999964.posop)
	c:RegisterEffect(e2)

end
function c999999964.synfilter(c)
	return  c:IsSetCard(0x984) or c:IsSetCard(0x985)
end
function c999999964.secon(e,tp,eg,ep,ev,re,r,rp)
return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c999999964.filter(c)
	local code=c:GetCode()
	return (code==999999968) 
end
function c999999964.setg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c999999964.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)  end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c999999964.seop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c999999964.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and tc:IsSSetable()
			and (not tc:IsAbleToHand() or Duel.SelectYesNo(tp,aux.Stringid(999997,7))) then
			Duel.SSet(tp,tc)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
end
end
function c999999964.costfilter(c)
	return c:IsDiscardable() and c:IsType(TYPE_SPELL) and c:IsType(TYPE_EQUIP)
end
function c999999964.poscost(e,tp,eg,ep,ev,re,r,rp,chk)
	--[[if  Duel.IsExistingMatchingCard(c999999995.ccfilter,tp,LOCATION_SZONE,0,1,nil) and Duel.GetFlagEffect(tp,999989938)==0 then
    if chk==0 then return Duel.GetFlagEffect(tp,999989938)==0  end
	Duel.RegisterFlagEffect(tp,999989938,RESET_PHASE+PHASE_END,0,1)
	 else--]]
	if chk==0 then return  Duel.IsExistingMatchingCard(c999999964.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c999999964.costfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c999999964.posfilter(c)
	return c:IsPosition(POS_FACEUP) and c:IsCanTurnSet()
end
function c999999964.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and c999999964.posfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c999999964.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler())   end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c999999964.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c999999964.posop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and  Duel.ChangePosition(tc,POS_FACEDOWN_DEFENCE)~=0 then
		e:GetHandler():CreateRelation(tc,RESET_EVENT+0x1fe0000)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetCondition(c999999964.poscon2)
		tc:RegisterEffect(e1)
	end
	end
function c999999964.poscon2(e)
	return e:GetOwner():IsRelateToCard(e:GetHandler())
end


