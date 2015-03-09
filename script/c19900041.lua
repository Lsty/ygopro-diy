--夜咄DECEIVE
function c19900041.initial_effect(c)
	c:SetUniqueOnField(1,0,19900041)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DRAW_PHASE,TIMING_END_PHASE)
	e1:SetTarget(c19900041.target1)
	e1:SetOperation(c19900041.operation)
	c:RegisterEffect(e1)
	--instant(chain)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(19900041,1))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(TIMING_DRAW_PHASE,TIMING_END_PHASE)
	e2:SetTarget(c19900041.target2)
	e2:SetOperation(c19900041.operation)
	c:RegisterEffect(e2)
end
function c19900041.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x199) and c:IsDestructable()
end
function c19900041.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c19900041.filter(chkc) end
	if chk==0 then return true end
	if Duel.IsExistingTarget(c19900041.filter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(19900041,0)) then
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e:SetCategory(CATEGORY_DESTROY)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectTarget(tp,c19900041.filter,tp,LOCATION_MZONE,0,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
		e:GetHandler():RegisterFlagEffect(19900041,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
		e:SetLabel(1)
	else
		e:SetProperty(0)
		e:SetCategory(0)
		e:SetLabel(0)
	end
end
function c19900041.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		tc:RegisterFlagEffect(19900042,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,0,2)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(19900041,2))
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
		e1:SetRange(LOCATION_SZONE)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetProperty(EFFECT_FLAG_REPEAT)
		e1:SetCountLimit(1)
		e1:SetLabelObject(tc)
		e1:SetCondition(c19900041.spcon)
		e1:SetTarget(c19900041.sptg)
		e1:SetOperation(c19900041.spop)
		if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_STANDBY then
			e1:SetLabel(Duel.GetTurnCount())
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,2)
		else
			e1:SetLabel(0)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
		end
		e:GetHandler():RegisterEffect(e1)
	end
end
function c19900041.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c19900041.filter(chkc) end
	if chk==0 then return e:GetHandler():GetFlagEffect(19900041)==0
		and Duel.IsExistingTarget(c19900041.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c19900041.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	e:GetHandler():RegisterFlagEffect(19900041,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c19900041.spcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return tc and tc:GetFlagEffect(19900042)~=0 and Duel.GetTurnPlayer()==tp and e:GetLabel()~=Duel.GetTurnCount()
end
function c19900041.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local tc=e:GetLabelObject()
	Duel.SetTargetCard(tc)
	e:SetLabelObject(nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tc,1,0,0)
end
function c19900041.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end