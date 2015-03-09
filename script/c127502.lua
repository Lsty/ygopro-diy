--时幻邪神 阿撒托斯
function c127502.initial_effect(c)
	--pendulum summon
	aux.AddPendulumProcedure(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_PZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1)
	e2:SetCondition(c127502.drcon)
	e2:SetTarget(c127502.target)
	e2:SetOperation(c127502.operation)
	c:RegisterEffect(e2)
end
function c127502.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x7fa) and c:IsType(TYPE_PENDULUM)
end
function c127502.drcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return Duel.GetTurnPlayer()~=tp and eg:IsExists(c127502.filter,1,nil) and tc:GetControler()==tp 
end
function c127502.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=eg:GetFirst()
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c127502.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	local rg=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,rg,LOCATION_HAND,0,nil)
	if g:GetCount()>=1 then
	local sg=g:Select(rg,1,1,nil)
	Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
	end
end

