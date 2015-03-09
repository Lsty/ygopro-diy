--奥尔良人形
function c999999899.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c999999899.spcon1)
	e1:SetTarget(c999999899.sptg)
	e1:SetOperation(c999999899.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BE_BATTLE_TARGET)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c999999899.spcon2)
	e2:SetTarget(c999999899.sptg)
	e2:SetOperation(c999999899.spop)
	c:RegisterEffect(e2)
	--cannot be target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e3:SetTarget(c999999899.tg)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetCondition(c999999899.con)
	e4:SetValue(c999999899.tglimit)
	c:RegisterEffect(e4)
end
function c999999899.spcon1(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	return at:GetControler()~=tp and Duel.GetAttackTarget()==nil
end
function c999999899.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttackTarget()
	return at:IsControler(tp) and at:IsFaceup() and at:IsSetCard(0xaa1)
end
function c999999899.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c999999899.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENCE) 
end
function c999999899.tg(e,c)
	return c:IsFaceup() and c:GetCode()~=999999899 and c:IsSetCard(0xaa1)
end
function c999999899.con(e,tp,eg,ep,ev,re,r,rp)
	return  Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_MZONE,0,1,nil,0xaa2)
end
function c999999899.tglimit(e,re,rp)
	return rp~=e:GetHandlerPlayer() 
end
