--魔王的随从 阿露露
function c11111014.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c11111014.spcon)
	e1:SetOperation(c11111014.spop)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--race fairy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_CHANGE_RACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(RACE_FAIRY)
	c:RegisterEffect(e2)
end
function c11111014.filter(c)
	return c:IsFaceup() and not c:IsCode(11111014) and c:GetLevel()==8
end
function c11111014.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetFlagEffect(tp,11111014)==0
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c11111014.filter,tp,LOCATION_MZONE,0,1,nil)
end
function c11111014.spop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.RegisterFlagEffect(tp,11111014,RESET_PHASE+PHASE_END,0,1)
end	