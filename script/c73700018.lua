--幻惑「花冠视线」
function c73700018.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c73700018.condition)
	e1:SetTarget(c73700018.target)
	e1:SetOperation(c73700018.activate)
	c:RegisterEffect(e1)
end
function c73700018.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0x737)
end
function c73700018.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c73700018.filter1,tp,LOCATION_MZONE,0,1,nil)
end
function c73700018.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)
end
function c73700018.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UNRELEASABLE_SUM)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+RESET_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UNRELEASABLE_NONSUM)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
		e3:SetValue(1)
		e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+RESET_END)
		tc:RegisterEffect(e3)
		local e4=e3:Clone()
		e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		tc:RegisterEffect(e4)
		local e5=e3:Clone()
		e5:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
		tc:RegisterEffect(e5)
		local e6=Effect.CreateEffect(c)
		e6:SetType(EFFECT_TYPE_SINGLE)
		e6:SetCode(EFFECT_MUST_ATTACK)
		e6:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e6)
		tc:RegisterFlagEffect(73700018,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
		local be=Effect.CreateEffect(c)
		be:SetType(EFFECT_TYPE_FIELD)
		be:SetCode(EFFECT_CANNOT_EP)
		be:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		be:SetTargetRange(0,1)
		be:SetCondition(c73700018.becon)
		be:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(be,tp)
		if Duel.SelectYesNo(tp,aux.Stringid(73700018,0)) then
			Duel.BreakEffect()
			Duel.ChangePosition(tc,POS_FACEUP_DEFENCE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
		end
	end
end
function c73700018.befilter(c)
	return c:GetFlagEffect(73700018)~=0 and c:IsAttackable()
end
function c73700018.becon(e)
	return Duel.IsExistingMatchingCard(c73700018.befilter,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil)
end