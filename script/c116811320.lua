--镜世录 天雷鼓
function c116811320.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,116811320)
	e1:SetCondition(c116811320.spcon)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(116811320,1))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,116811321)
	e2:SetCost(c116811320.spcost)
	e2:SetTarget(c116811320.sptg)
	e2:SetOperation(c116811320.spop)
	c:RegisterEffect(e2)
end
function c116811320.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x3e2) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c116811320.efilter(c)
	return c:IsType(TYPE_MONSTER)
end
function c116811320.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>Duel.GetMatchingGroupCount(c116811320.efilter,tp,LOCATION_MZONE,0,nil)
		and Duel.IsExistingMatchingCard(c116811320.filter,tp,LOCATION_SZONE,0,1,nil)
end
function c116811320.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3e2) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGraveAsCost()
end
function c116811320.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c116811320.cfilter,tp,LOCATION_ONFIELD,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c116811320.cfilter,tp,LOCATION_ONFIELD,0,2,2,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c116811320.spfilter(c,e,tp)
	return c:IsSetCard(0x3e2) and c:GetCode()~=116811320 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c116811320.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c116811320.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c116811320.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c116811320.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c116811320.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end