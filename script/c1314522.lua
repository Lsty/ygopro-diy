--夜夜 光焰
function c1314522.initial_effect(c)
    --atk
    local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetCondition(c1314522.atkcon)
	e1:SetValue(500)
	c:RegisterEffect(e1)
	--to defence
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_DAMAGE_STEP_END)
	e2:SetOperation(c1314522.posop)
	c:RegisterEffect(e2)
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(c1314522.damop)
	c:RegisterEffect(e3)
end
function c1314522.atkcon(e)
    if Duel.GetAttacker()~=e:GetHandler() then return false end
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL)
end	
function c1314522.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsAttackPos() and c:IsRelateToBattle() then
		Duel.ChangePosition(c,0x4)
	end
end
function c1314522.damop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	if c:IsDefencePos() and Duel.GetAttackTarget()==c then
	   Duel.Damage(tp,1000,0x40)
   end
end   
	