--弱心「丧心丧意」
function c73700015.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	e1:SetCondition(c73700015.condition)
	e1:SetTarget(c73700015.target)
	e1:SetOperation(c73700015.activate)
	c:RegisterEffect(e1)
end
function c73700015.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_GRAVE,0,1,nil,0x737)
end
function c73700015.filter(c)
	return c:IsFaceup() and not c:IsDisabled() and not c:IsType(TYPE_NORMAL)
end
function c73700015.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() and c73700015.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c73700015.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c73700015.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c73700015.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0x737)
end
function c73700015.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e3)
		end
	end
	if Duel.IsExistingMatchingCard(c73700015.filter1,tp,LOCATION_MZONE,0,1,nil) then
		local sg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
		if sg:GetCount()>0 then
			local tc=sg:GetFirst()
			while tc do
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_MUST_ATTACK)
				e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e1)
				tc:RegisterFlagEffect(73700015,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
				tc=sg:GetNext()
			end
		end
		local be=Effect.CreateEffect(c)
		be:SetType(EFFECT_TYPE_FIELD)
		be:SetCode(EFFECT_CANNOT_EP)
		be:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		be:SetTargetRange(0,1)
		be:SetCondition(c73700015.becon)
		be:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(be,tp)
		if Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_MZONE,1,nil)
			and Duel.SelectYesNo(tp,aux.Stringid(73700015,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DEFENCE)
			local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)
			if g:GetCount()>0 then
				Duel.HintSelection(g)
				Duel.ChangePosition(g,POS_FACEUP_DEFENCE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_MUST_ATTACK)
				e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
				g:GetFirst():RegisterEffect(e1)
				g:GetFirst():RegisterFlagEffect(73700015,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
			end
		end
	end
end
function c73700015.befilter(c)
	return c:GetFlagEffect(73700015)~=0 and c:IsAttackable()
end
function c73700015.becon(e)
	return Duel.IsExistingMatchingCard(c73700015.befilter,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil)
end