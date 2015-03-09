--神天龙-遗龙
function c9991201.initial_effect(c)
	--Special Summon From Hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9991201,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetRange(LOCATION_HAND)
	e1:SetTargetRange(POS_FACEUP_DEFENCE,0)
	e1:SetValue(0x40000fff)
	e1:SetCondition(c9991201.spcon)
	e1:SetOperation(c9991201.spop)
	c:RegisterEffect(e1)
	--Hand Fusion
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9991201,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,9991201)
	e2:SetTarget(c9991201.hftg)
	e2:SetOperation(c9991201.hfop)
	c:RegisterEffect(e2)
	--Xyz Limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e3:SetCondition(c9991201.xlcon)
	e3:SetValue(aux.TRUE)
	c:RegisterEffect(e3)
end
function c9991201.spfilter(c)
	return c:IsRace(RACE_WYRM) and c:IsAbleToGraveAsCost()
end
function c9991201.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9991201.spfilter,tp,LOCATION_HAND,0,1,c)
end
function c9991201.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c9991201.spfilter,tp,LOCATION_HAND,0,1,1,c)
	Duel.SendtoGrave(g,REASON_COST)
end
function c9991201.filter1(c,e,tp)
	return c:IsRace(RACE_WYRM) and c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e) and Duel.IsExistingMatchingCard(c9991201.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c:GetAttribute())
end
function c9991201.filter2(c,e,tp,attr)
	return c:IsSetCard(0xfff) and c:IsType(TYPE_FUSION) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:IsAttribute(attr) and c:GetLevel()==10
end
function c9991201.hftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and Duel.IsExistingMatchingCard(c9991201.filter1,tp,LOCATION_HAND,0,1,e:GetHandler(),e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c9991201.hfop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not e:GetHandler():IsRelateToEffect(e) then return end
	if not Duel.IsExistingMatchingCard(c9991201.filter1,tp,LOCATION_HAND,0,1,e:GetHandler(),e,tp) then return end
	local fm=Group.CreateGroup()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g1=Duel.SelectMatchingCard(tp,c9991201.filter1,tp,LOCATION_HAND,0,1,1,e:GetHandler(),e,tp)
	Duel.ConfirmCards(1-tp,g1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectMatchingCard(tp,c9991201.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,g1:GetFirst():GetAttribute())
	g1:AddCard(e:GetHandler())
	g2:GetFirst():SetMaterial(g1)
	Duel.SendtoGrave(g1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
	Duel.BreakEffect()
	Duel.SpecialSummon(g2,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP) g2:GetFirst():CompleteProcedure()
end
function c9991201.xlcon(e,c)
	return e:GetHandler():IsDefencePos()
end
