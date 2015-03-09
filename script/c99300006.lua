--秘封·大空魔术
function c99300006.initial_effect(c)
	--Negate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCondition(c99300006.discon3)
	e1:SetValue(TYPE_SPELL)
	c:RegisterEffect(e1)
	--Negate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CHANGE_TYPE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCondition(c99300006.discon)
	e2:SetValue(TYPE_TRAP)
	c:RegisterEffect(e2)
	--Activate
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCondition(c99300006.discon1)
	e3:SetCost(c99300006.cost)
	e3:SetTarget(c99300006.target)
	e3:SetOperation(c99300006.activate)
	c:RegisterEffect(e3)
	--Activate
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetType(EFFECT_TYPE_ACTIVATE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCondition(c99300006.discon2)
	e4:SetCost(c99300006.cost)
	e4:SetTarget(c99300006.target1)
	e4:SetOperation(c99300006.activate1)
	c:RegisterEffect(e4)
end
function c99300006.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,99300006)==0 end
	Duel.RegisterFlagEffect(tp,99300006,RESET_PHASE+PHASE_END,0,1)
end
function c99300006.discon3(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_HAND)
end
function c99300006.discon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsFacedown() and e:GetHandler():IsLocation(LOCATION_SZONE)
end
function c99300006.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x993)
end
function c99300006.discon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsFacedown() and Duel.IsExistingMatchingCard(c99300006.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c99300006.discon1(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsFacedown() and Duel.GetCurrentChain()==0 and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function c99300006.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x993) and c:IsAbleToHand()
end
function c99300006.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c99300006.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c99300006.filter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c99300006.filter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c99300006.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c99300006.filter1(c)
	return c:IsFaceup() and c:IsAbleToRemove()
end
function c99300006.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c99300006.filter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c99300006.filter1,tp,0,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c99300006.filter1,tp,0,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(TYPE_TRAP)
	e:GetHandler():RegisterEffect(e1)
end
function c99300006.activate1(e)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		if tc:IsType(TYPE_MONSTER) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCountLimit(1)
			e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
			e1:SetCondition(c99300006.spcon)
			e1:SetOperation(c99300006.spop)
			e1:SetLabelObject(tc)
			e1:SetLabel(Duel.GetTurnCount())
			e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,2)
			Duel.RegisterEffect(e1,tc:GetControler())
			tc:RegisterFlagEffect(99300006,RESET_EVENT+0x1fe0000,0,0)
		end
	end
end
function c99300006.spcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return Duel.GetTurnCount()~=e:GetLabel() and Duel.GetTurnPlayer()==tc:GetControler()
		and tc:GetFlagEffect(99300006)~=0 and tc:GetReasonEffect():GetHandler()==e:GetHandler()
end
function c99300006.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SpecialSummon(e:GetLabelObject(),0,tp,e:GetLabelObject():GetControler(),false,false,POS_FACEUP_DEFENCE)
end