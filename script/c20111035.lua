--克洛斯贝尔-「港湾区」
function c20111035.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--direct attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c20111035.target1)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c20111035.target2)
	e2:SetValue(c20111035.tgval)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CVAL_CHECK)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetCode(EVENT_RELEASE)
	e3:SetCost(c20111035.cost)
	e3:SetTarget(c20111035.target)
	e3:SetOperation(c20111035.activate)
	c:RegisterEffect(e3)
	--summon proc
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(20111035,0))
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_SUMMON_PROC)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_HAND,0)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x929))
	e4:SetCondition(c20111035.sumcon)
	e4:SetOperation(c20111035.sumop)
	e4:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_SET_PROC)
	c:RegisterEffect(e5)
end
function c20111035.target1(e,c)
	return c:IsType(TYPE_MONSTER)
end
function c20111035.target2(e,c)
	return c:IsSetCard(0x929) and c:IsType(TYPE_MONSTER)
end
function c20111035.tgval(e,re,rp)
	return e:GetHandlerPlayer()~=rp
end
function c20111035.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsReleasable()
end
function c20111035.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c20111035.cfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	local g=Duel.SelectTarget(tp,c20111035.cfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c20111035.filter(c,e,tp)
	return c:IsSetCard(0x929) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c20111035.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c20111035.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c20111035.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c20111035.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c20111035.sumcon(e,c)
	if c==nil then return e:GetHandler():IsReleasable() end
	local mi,ma=c:GetTributeRequirement()
	return ma>0 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c20111035.sumop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Release(e:GetHandler(),REASON_COST)
end
