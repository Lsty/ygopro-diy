--梅梅
function c3036105.initial_effect(c)
	c:SetStatus(STATUS_UNSUMMONABLE_CARD,true)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(86585274,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,3036105)
	e1:SetCost(c3036105.spcost)
	e1:SetTarget(c3036105.sptg)
	e1:SetOperation(c3036105.spop)
	c:RegisterEffect(e1)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(86585274,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c3036105.target)
	e1:SetOperation(c3036105.operation)
	c:RegisterEffect(e1)
end
function c3036105.spfilter1(c)
	return c:GetLevel()==7 and c:IsAttribute(ATTRIBUTE_WIND) and not c:IsPublic()
end
function c3036105.spfilter2(c)
	return c:GetLevel()==7 and c:IsAttribute(ATTRIBUTE_LIGHT) and not c:IsPublic()
end
function c3036105.spfilter3(c)
	return c:GetLevel()==7 and c:IsAttribute(ATTRIBUTE_DARK) and not c:IsPublic()
end
function c3036105.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c3036105.spfilter1,tp,LOCATION_HAND,0,1,nil,nil)
		and Duel.IsExistingMatchingCard(c3036105.spfilter2,tp,LOCATION_HAND,0,1,nil,nil)
		and Duel.IsExistingMatchingCard(c3036105.spfilter3,tp,LOCATION_HAND,0,1,nil,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g1=Duel.SelectMatchingCard(tp,c3036105.spfilter1,tp,LOCATION_HAND,0,1,1,nil,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g2=Duel.SelectMatchingCard(tp,c3036105.spfilter2,tp,LOCATION_HAND,0,1,1,nil,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g3=Duel.SelectMatchingCard(tp,c3036105.spfilter3,tp,LOCATION_HAND,0,1,1,nil,nil)
	g1:Merge(g2)
	g1:Merge(g3)
	Duel.ConfirmCards(1-tp,g1)
	Duel.ShuffleHand(tp)
end
function c3036105.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c3036105.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c3036105.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c3036105.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c3036105.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c3036105.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
    Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c3036105.filter(c,e,tp)
	return c:IsAbleToGrave() and c:GetLevel()==7
end