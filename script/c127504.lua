--时幻魔术师 伊丝
function c127504.initial_effect(c)
	--pendulum summon
	aux.AddPendulumProcedure(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,127504)
	e2:SetCondition(c127504.condition)
	e2:SetTarget(c127504.target)
	e2:SetOperation(c127504.operation)
	c:RegisterEffect(e2)
end
function c127504.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x7fa) and c:IsType(TYPE_MONSTER)
end
function c127504.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()and Duel.IsExistingMatchingCard(c127504.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c127504.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tg=Duel.GetAttacker()
	if chkc then return chkc==tg end
	if chk==0 then return tg:IsOnField() and tg:IsCanBeEffectTarget(e) end
	Duel.SetTargetCard(tg)
end
function c127504.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and Duel.NegateAttack() and c:IsRelateToEffect(e) then
		Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE,1)
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
