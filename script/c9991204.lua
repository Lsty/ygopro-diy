--神天龙-闪龙
function c9991204.initial_effect(c)
	--Special Summon From Hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9991204,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetRange(LOCATION_HAND)
	e1:SetTargetRange(POS_FACEUP_DEFENCE,0)
	e1:SetValue(0x40000fff)
	e1:SetCondition(c9991204.spcon)
	e1:SetOperation(c9991204.spop)
	c:RegisterEffect(e1)
	--Special Summon From Removed
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9991204,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,9991204)
	e2:SetCost(c9991204.cost1)
	e2:SetTarget(c9991204.tg1)
	e2:SetOperation(c9991204.op1)
	c:RegisterEffect(e2)
	--Fuck Monster
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9991204,2))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCountLimit(1,9991204)
	e3:SetCondition(c9991204.con2)
	e3:SetTarget(c9991204.tg2)
	e3:SetOperation(c9991204.op2)
	c:RegisterEffect(e3)
	--Xyz Limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e4:SetCondition(c9991204.xlcon)
	e4:SetValue(aux.TRUE)
	c:RegisterEffect(e4)
end
function c9991204.spfilter(c)
	return c:IsRace(RACE_WYRM) and c:IsAbleToGraveAsCost()
end
function c9991204.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9991204.spfilter,tp,LOCATION_HAND,0,1,c)
end
function c9991204.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c9991204.spfilter,tp,LOCATION_HAND,0,1,1,c)
	Duel.SendtoGrave(g,REASON_COST)
end
function c9991204.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c9991204.filter(c,e,tp,code)
	return c:IsSetCard(0xfff) and c:IsCanBeSpecialSummoned(e,0x40000fff,tp,false,false) and c:GetCode()~=code
end
function c9991204.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9991204.filter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil,e,tp,e:GetHandler():GetCode()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
end
function c9991204.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9991204.filter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil,e,tp,e:GetHandler():GetCode())
	if g:GetCount()>0 then Duel.HintSelection(g) Duel.SpecialSummon(g,0x40000fff,tp,tp,false,false,POS_FACEUP_DEFENCE) end
end
function c9991204.con2(e,tp,eg,ep,ev,re,r,rp)
	return ( not e:GetHandler():IsLocation(LOCATION_DECK) ) and r==REASON_FUSION and e:GetHandler():GetReasonCard():IsSetCard(0xfff)
end
function c9991204.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroupCount(Card.IsDestructable,tp,0,LOCATION_MZONE,nil)~=0 end
	local sg=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,1,0,0)
end
function c9991204.op2(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_MZONE,nil)
	if sg and sg:GetCount()~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local rg=sg:Select(tp,1,1,nil)
		Duel.HintSelection(rg)
		Duel.Destroy(rg,REASON_EFFECT)
	end
end
function c9991204.xlcon(e,c)
	return e:GetHandler():IsDefencePos()
end
