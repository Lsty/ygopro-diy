--水之妖精 琪露诺
function c116810909.initial_effect(c)
	c:EnableReviveLimit()
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetDescription(aux.Stringid(116810909,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c116810909.condition)
	e1:SetTarget(c116810909.target)
	e1:SetOperation(c116810909.operation)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetDescription(aux.Stringid(116810909,1))
	e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c116810909.con)
	e2:SetCost(c116810909.cost)
	e2:SetOperation(c116810909.op)
	c:RegisterEffect(e2)
end
function c116810909.con(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if not d then return false end
	return (a:GetControler()==tp and a:IsSetCard(0x3e6))
		or (d:GetControler()==tp and d:IsSetCard(0x3e6))
end
function c116810909.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c116810909.op(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=Duel.GetAttacker()
	if Duel.GetTurnPlayer()~=tp then a=Duel.GetAttackTarget() end
	if not a:IsRelateToBattle() then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE_CAL)
	e1:SetValue(1)
	a:RegisterEffect(e1)
end
function c116810909.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_RITUAL
end
function c116810909.filter(c,def)
	return c:IsFaceup() and c:GetDefence()<=def and c:IsDestructable()
end
function c116810909.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c116810909.filter,tp,LOCATION_MZONE,LOCATION_MZONE,c,c:GetDefence())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c116810909.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c116810909.filter,tp,LOCATION_MZONE,LOCATION_MZONE,c,c:GetDefence())
	local ct=Duel.Destroy(g,REASON_EFFECT)
	if ct>0 then
	  Duel.Recover(tp,ct*1000,REASON_EFFECT)
	end
end
