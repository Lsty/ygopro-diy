--禁忌·红莓的陷阱
function c87700010.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(c87700010.condition)
	e1:SetTarget(c87700010.target)
	e1:SetOperation(c87700010.activate)
	c:RegisterEffect(e1)
end
function c87700010.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x877)
end
function c87700010.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c87700010.cfilter,tp,LOCATION_MZONE,0,1,nil) and tp~=Duel.GetTurnPlayer()
end
function c87700010.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tg=Duel.GetAttacker()
	if chkc then return chkc==tg end
	if chk==0 then return tg:IsOnField() and tg:IsCanBeEffectTarget(e) end
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,1)
end
function c87700010.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and Duel.NegateAttack() then
		Duel.Draw(1-tp,1,REASON_EFFECT)
		Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1,1)
		Duel.SkipPhase(1-tp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
	end
end