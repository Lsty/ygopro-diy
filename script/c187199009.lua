--聖殿騎士
function c187199009.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(72989439,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c187199009.spcon)
	e1:SetOperation(c187199009.spop)
	c:RegisterEffect(e1)
	--selfdes
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EFFECT_SELF_DESTROY)
	e7:SetCondition(c187199009.descon)
	c:RegisterEffect(e7)
	--indes
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD)
	e9:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e9:SetRange(LOCATION_MZONE)
	e9:SetTargetRange(LOCATION_SZONE,0)
	e9:SetTarget(c187199009.indes)
	e9:SetValue(1)
	c:RegisterEffect(e9)
   	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(28637168,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c187199009.tg)
	e1:SetOperation(c187199009.op)
	c:RegisterEffect(e1)
end
function c187199009.indes(e,c)
	return c:IsFaceup() and c:IsCode(187199010)
end
function c187199009.spfilter(c,att)
	return c:IsSetCard(0x3e1) and c:IsAbleToRemoveAsCost() and c:IsType(TYPE_MONSTER)
end
function c187199009.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c187199009.spfilter,tp,LOCATION_GRAVE,0,1,nil,nil)
end
function c187199009.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,c187199009.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
end
function c187199009.descon(e)
	return not Duel.IsExistingMatchingCard(c187199009.filter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function c187199009.filter(c)
	return c:IsCode(187199010) and c:IsFaceup()
end
function c187199009.afilter(c)
	return c:IsFaceup() and c:IsCanTurnSet() and not c:IsCode(187199009)
end
function c187199009.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c187199009.afilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
    end
	local g=Duel.GetMatchingGroup(c187199009.afilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function c187199009.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c187199009.afilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		Duel.ChangePosition(g,POS_FACEDOWN_DEFENCE)
	end
end