--兄贵⑨
function c116810880.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x3e6),aux.NonTuner(Card.IsSetCard,0x3e6),2)
	c:EnableReviveLimit()
	--damage&recover
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(116810880,0))
	e2:SetCategory(CATEGORY_DAMAGE+CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_DAMAGE_STEP_END)
	e2:SetTarget(c116810880.damtg)
	e2:SetOperation(c116810880.damop)
	c:RegisterEffect(e2)
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetValue(c116810880.efilter)
	c:RegisterEffect(e3)
end
function c116810880.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetAttackTarget()~=nil end
	local c=e:GetHandler()
	local d=Duel.GetAttackTarget()
	if d==c then d=Duel.GetAttacker() end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,d:GetDefence())
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,d:GetAttack())
end
function c116810880.damop(e,tp,eg,ep,ev,re,r,rp)
	local ex1,a1,b1,p1,d1=Duel.GetOperationInfo(0,CATEGORY_DAMAGE)
	local ex2,a2,b2,p2,d2=Duel.GetOperationInfo(0,CATEGORY_RECOVER)
	Duel.Damage(1-tp,d1,REASON_EFFECT)
	Duel.Recover(tp,d2,REASON_EFFECT)
end
function c116810880.efilter(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetOwner()~=e:GetOwner()
end