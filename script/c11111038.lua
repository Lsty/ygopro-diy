--魂流共鸣
function c11111038.initial_effect(c)
	c:SetUniqueOnField(1,0,11111038)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11111038,0))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c11111038.condition)
	e2:SetCost(c11111038.cost)
	e2:SetTarget(c11111038.target)
	e2:SetOperation(c11111038.operation)
	c:RegisterEffect(e2)
end
function c11111038.filter(c,tp)
	return c:IsSetCard(0x15d) and c:IsControler(tp) and c:GetSummonType()==SUMMON_TYPE_XYZ
end	
function c11111038.condition(e,tp,eg,ep,ev,re,r,rp)
    local tc=eg:GetFirst()
	return eg:IsExists(c11111038.filter,1,nil,tp) 
end
function c11111038.cfilter(c,att)
	return c:IsAttribute(att) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c11111038.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e)
		and Duel.IsExistingMatchingCard(c11111038.cfilter,tp,LOCATION_GRAVE,0,1,nil,eg:GetFirst():GetAttribute()) end
	e:SetLabel(eg:GetFirst():GetAttribute())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c11111038.cfilter,tp,LOCATION_GRAVE,0,1,1,nil,e:GetLabel())
	Duel.Remove(g,POS_FACEUP,REASON_COST)	
end
function c11111038.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c11111038.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c11111038.attg)
	e1:SetReset(RESET_PHASE+RESET_END)
	Duel.RegisterEffect(e1,tp)
end
function c11111038.attg(e,c)
	return not c:IsSetCard(0x15d)
end