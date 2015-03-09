--守护命的青龙 华玲
function c3036107.initial_effect(c)
	c:SetStatus(STATUS_UNSUMMONABLE_CARD,true)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(86585274,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCost(c3036107.spcost)
	e1:SetTarget(c3036107.sptg)
	e1:SetOperation(c3036107.spop)
	c:RegisterEffect(e1)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(86585274,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c3036107.target)
	e1:SetOperation(c3036107.operation)
	c:RegisterEffect(e1)
end
function c3036107.spfilter1(c)
	return c:GetLevel()==7 and c:IsAttribute(ATTRIBUTE_WATER)
end
function c3036107.spfilter2(c)
	return c:GetLevel()==7 and c:IsAttribute(ATTRIBUTE_DARK)
end
function c3036107.spfilter3(c)
	return c:GetLevel()==7 and c:IsAttribute(ATTRIBUTE_WIND)
end
function c3036107.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c3036107.spfilter1,tp,LOCATION_HAND,0,1,nil,nil)
		and Duel.IsExistingMatchingCard(c3036107.spfilter2,tp,LOCATION_HAND,0,1,nil,nil)
		and Duel.IsExistingMatchingCard(c3036107.spfilter3,tp,LOCATION_HAND,0,1,nil,nil)
		and Duel.GetFlagEffect(tp,3036107)==0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g1=Duel.SelectMatchingCard(tp,c3036107.spfilter1,tp,LOCATION_HAND,0,1,1,nil,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g2=Duel.SelectMatchingCard(tp,c3036107.spfilter2,tp,LOCATION_HAND,0,1,1,nil,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g3=Duel.SelectMatchingCard(tp,c3036107.spfilter3,tp,LOCATION_HAND,0,1,1,nil,nil)
	g1:Merge(g2)
	g1:Merge(g3)
	Duel.ConfirmCards(1-tp,g1)
	Duel.ShuffleHand(tp)
	Duel.RegisterFlagEffect(tp,3036107,RESET_PHASE+PHASE_END,0,1)
end
function c3036107.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c3036107.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c3036107.afilter(c)
	return c:IsAbleToDeck()
end
function c3036107.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c3036107.spfilter1,tp,LOCATION_DECK,0,1,nil,nil)
		and Duel.IsExistingMatchingCard(c3036107.spfilter2,tp,LOCATION_DECK,0,1,nil,nil)
		and Duel.IsExistingMatchingCard(c3036107.spfilter3,tp,LOCATION_DECK,0,1,nil,nil)
		and Duel.IsExistingMatchingCard(c3036107.afilter,tp,LOCATION_HAND,0,3,e:GetHandler()) end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND+CATEGORY_SEARCH,nil,0,tp,1)
end
function c3036107.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetMatchingGroup(c3036107.afilter,p,LOCATION_HAND,0,nil)
	if g:GetCount()<3 then
		local hg=Duel.GetFieldGroup(p,LOCATION_HAND,0)
		Duel.ConfirmCards(1-p,hg)
		Duel.ShuffleHand(p)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=g:Select(p,3,3,nil)
		Duel.SendtoDeck(sg,nil,3,REASON_EFFECT)
		Duel.ShuffleDeck(p)
	end
	local g4=Duel.GetFirstMatchingCard(c3036107.spfilter1,tp,LOCATION_DECK,0,nil)
	Duel.SendtoHand(g4,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g4)
	local g5=Duel.GetFirstMatchingCard(c3036107.spfilter2,tp,LOCATION_DECK,0,nil)
	Duel.SendtoHand(g5,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g5)
	local g6=Duel.GetFirstMatchingCard(c3036107.spfilter3,tp,LOCATION_DECK,0,nil)
	Duel.SendtoHand(g6,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g6)
	Duel.ShuffleHand(tp)
end
