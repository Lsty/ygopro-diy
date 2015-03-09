--神葬「使徒结界」
function c14700014.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCondition(c14700014.condition)
	e1:SetCost(c14700014.cost)
	e1:SetTarget(c14700014.target)
	e1:SetOperation(c14700014.activate)
	c:RegisterEffect(e1)
	--sset
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,14700014+EFFECT_COUNT_CODE_DUEL)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCost(c14700014.setcost)
	e2:SetTarget(c14700014.settg)
	e2:SetOperation(c14700014.setop)
	c:RegisterEffect(e2)
end
function c14700014.cfilter(c)
	return not (c:IsSetCard(0x147) or (c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_AQUA)))
end
function c14700014.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c14700014.cfilter,tp,LOCATION_GRAVE,0,1,nil)
end
function c14700014.filter1(c,e,tp)
	return c:IsType(TYPE_XYZ) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_AQUA)
		and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c14700014.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=99
	local g=Duel.GetMatchingGroup(c14700014.filter1,tp,LOCATION_EXTRA,0,nil,e,tp)
	local tc=g:GetFirst()
	while tc do
		if rc>tc:GetRank()-3 then
			rc=tc:GetRank()-3
		end
		tc=g:GetNext()
	end
	if rc<=0 then rc=1 end
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,rc,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local cg=Duel.SelectMatchingCard(tp,Card.IsDiscardable,tp,LOCATION_HAND,0,rc,5,nil)
	Duel.SendtoGrave(cg,REASON_COST+REASON_DISCARD)
	e:SetLabel(cg:GetCount())
end
function c14700014.filter2(c,e,tp,rk)
	return c:GetRank()<=rk and c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_AQUA)
		and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c14700014.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c14700014.activate(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c14700014.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,ct+3)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end
function c14700014.setfilter(c)
	return c:IsSetCard(0x147) and c:IsAbleToRemoveAsCost()
end
function c14700014.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=99
	local g=Duel.GetMatchingGroup(c14700014.filter1,tp,LOCATION_EXTRA,0,nil,e,tp)
	local tc=g:GetFirst()
	while tc do
		if rc>tc:GetRank() then
			rc=tc:GetRank()
		end
		tc=g:GetNext()
	end
	if chk==0 then return Duel.IsExistingMatchingCard(c14700014.setfilter,tp,LOCATION_GRAVE,0,rc,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c14700014.setfilter,tp,LOCATION_GRAVE,0,rc,8,e:GetHandler())
	g:AddCard(e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetLabel(g:GetCount())
end
function c14700014.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c14700014.setop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c14700014.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,ct-1)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end