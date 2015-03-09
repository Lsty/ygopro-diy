--虚无超越 麻美
function c9991008.initial_effect(c)
	--Synchro
	aux.AddSynchroProcedure2(c,nil,aux.FilterBoolFunction(Card.IsCode,9991004))
	c:EnableReviveLimit()
	--Destruction Immunity
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c9991008.ebcon)
	c:RegisterEffect(e1)
	--Destroy & Position Change
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_POSITION)
	e2:SetDescription(aux.Stringid(9991008,0))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c9991008.dpctg)
	e2:SetOperation(c9991008.dpcop)
	c:RegisterEffect(e2)
	--Last Will
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c9991008.lwcon)
	e3:SetTarget(c9991008.lwtg)
	e3:SetOperation(c9991008.lwop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EVENT_TO_DECK)
	c:RegisterEffect(e5)
end
function c9991008.ebcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0
end
function c9991008.dpctg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and c9991008.dpcfilter(chkc) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(c9991008.dpcfilter,tp,LOCATION_SZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local d1=Duel.SelectTarget(tp,c9991008.dpcfilter,tp,LOCATION_SZONE,0,1,1,nil)
	local d2=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_SZONE,nil)
	local c1=Duel.GetMatchingGroup(aux.TURE,tp,0,LOCATION_MZONE,nil)
	if d2:GetCount()~=0 then Duel.SetOperationInfo(0,CATEGORY_DESTROY,d1 and d2,d2:GetCount()+1,0,0) else Duel.SetOperationInfo(0,CATEGORY_DESTROY,d1,1,0,0) end
	if c1:GetCount()~=0 then Duel.SetOperationInfo(0,CATEGORY_POSITION,c1,c1:GetCount(),0,0) end
	if e:GetHandler():GetOriginalCode()~=9991008 then Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription()) end
end
function c9991008.dpcfilter(c)
	return c:IsFaceup() and (c:GetSequence()==6 or c:GetSequence()==7) and c:IsDestructable()
end
function c9991008.dpcop(e,tp,eg,ep,ev,re,r,rp)
	local d1=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e):GetFirst() if not d1 then return end
	local d2=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_SZONE,nil)
	local c1=Duel.GetMatchingGroup(aux.TURE,tp,0,LOCATION_MZONE,nil)
	if d2:GetCount()~=0 then d2:AddCard(d1) Duel.Destroy(d2,REASON_EFFECT) else Duel.Destroy(d1,REASON_EFFECT) end
	if c1:GetCount()~=0 then Duel.ChangePosition(c1,POS_FACEUP_DEFENCE,POS_FACEUP_DEFENCE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,true) end
end
function c9991008.lwcon(e,tp,eg,ep,ev,re,r,rp,chk)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c9991008.filter(c)
	return c:IsCode(9991004) and c:IsAbleToHand()
end
function c9991008.lwtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9991008.filter,tp,0x51,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x51)
end
function c9991008.lwop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9991008.filter,tp,0x51,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
