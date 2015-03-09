--克洛斯贝尔－「兰花塔」
function c20111041.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c20111041.spcost)
	e1:SetTarget(c20111041.sptg)
	e1:SetOperation(c20111041.spop)
	c:RegisterEffect(e1)
end
function c20111041.cfilter(c)
	return c:IsSetCard(0x930) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemoveAsCost()
end
function c20111041.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c20111041.cfilter,tp,LOCATION_GRAVE,0,7,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c20111041.cfilter,tp,LOCATION_GRAVE,0,7,7,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c20111041.filter(c,e,tp)
	return c:IsSetCard(0x929) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c20111041.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingMatchingCard(c20111041.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c20111041.sfilter(c)
	return c:IsSetCard(0x930) and c:GetCode()~=20111041 and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c20111041.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c20111041.filter,tp,LOCATION_GRAVE,0,ft,ft,nil,e,tp)
	if g:GetCount()==0 then return end
	local ct=Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	if ct>0 then
		local sg=Duel.GetMatchingGroup(c20111041.sfilter,tp,LOCATION_DECK,0,nil)
		if sg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(20111041,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local setg=sg:Select(tp,1,ct,nil)
			Duel.SendtoHand(setg,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,setg)
		end
	end
end
