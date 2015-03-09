--「刻刻帝」 十二之弹（Yud·Bet）
function c127813.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c127813.condition)
	e1:SetCost(c127813.cost)
	e1:SetTarget(c127813.target)
	e1:SetOperation(c127813.activate)
	c:RegisterEffect(e1)
end
function c127813.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and Duel.GetCurrentPhase()==PHASE_MAIN1
end
function c127813.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local fd=Duel.GetFieldCard(c:GetControler(),LOCATION_SZONE,5)
	if chk==0 then return fd and fd:IsCode(127808) and fd:IsCanRemoveCounter(c:GetControler(),0x16,5,REASON_COST) end
	local fd=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	fd:RemoveCounter(tp,0x16,5,REASON_RULE)
end
function c127813.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(1-tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,1)
end
function c127813.activate(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.Draw(1-tp,1,REASON_EFFECT)
	if ct==0 then return end
	Duel.BreakEffect()
	Duel.SkipPhase(1-tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,1-tp)
end
