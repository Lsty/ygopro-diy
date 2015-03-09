--神天龙-影龙
function c9991207.initial_effect(c)
	--Special Summon From Hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetRange(LOCATION_HAND)
	e1:SetTargetRange(POS_FACEUP_ATTACK,0)
	e1:SetValue(0x40000fff)
	e1:SetCondition(c9991207.spcon)
	e1:SetOperation(c9991207.spop)
	c:RegisterEffect(e1)
	--To Hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,9991207)
	e2:SetCost(c9991207.cost1)
	e2:SetTarget(c9991207.target1)
	e2:SetOperation(c9991207.operation1)
	c:RegisterEffect(e2)
	--Special Summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_REMOVED)
	e3:SetCountLimit(1,9991207)
	e3:SetCost(c9991207.cost2)
	e3:SetTarget(c9991207.target2)
	e3:SetOperation(c9991207.operation2)
	c:RegisterEffect(e3)
	--Xyz Limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e4:SetCondition(c9991207.xlcon)
	e4:SetValue(aux.TRUE)
	c:RegisterEffect(e4)
end
function c9991207.spfilter(c)
	return c:IsRace(RACE_WYRM) and c:IsAbleToGraveAsCost()
end
function c9991207.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9991207.spfilter,tp,LOCATION_HAND,0,1,c)
end
function c9991207.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c9991207.spfilter,tp,LOCATION_HAND,0,1,1,c)
	Duel.SendtoGrave(g,REASON_COST)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e1,true)
end
function c9991207.xlcon(e,c)
	return e:GetHandler():IsAttackPos()
end
function c9991207.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c9991207.thfilter(c,e,code)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xfff) and c:GetCode()~=code
end
function c9991207.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroupCount(c9991207.thfilter,tp,0x10,0,nil,e,e:GetHandler():GetCode())~=0 end
	local sg=Duel.GetMatchingGroup(c9991207.thfilter,tp,0x10,0,nil,e,e:GetHandler():GetCode())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,1,0,0)
end
function c9991207.operation1(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c9991207.thfilter,tp,0x10,0,nil,e,e:GetHandler():GetCode())
	if sg and sg:GetCount()~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local rg=sg:Select(tp,1,1,nil)
		Duel.HintSelection(rg)
		Duel.SendtoHand(rg,nil,REASON_EFFECT)
	end
end
function c9991207.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_RETURN)
end
function c9991207.filter(c,e,tp,code)
	return c:IsSetCard(0xfff) and c:IsCanBeSpecialSummoned(e,0x40000fff,tp,false,false) and c:GetCode()~=code and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c9991207.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c9991207.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp,e:GetHandler():GetCode()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c9991207.operation2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9991207.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp,e:GetHandler():GetCode())
	if g:GetCount()>0 then Duel.HintSelection(g) Duel.SpecialSummon(g,0x40000fff,tp,tp,false,false,POS_FACEUP) end
end
