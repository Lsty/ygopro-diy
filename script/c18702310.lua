--操鸟师 冰雀
function c18702310.initial_effect(c)
   	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(28637168,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,18702310)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c18702310.target2)
	e1:SetOperation(c18702310.operation2)
	c:RegisterEffect(e1)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(69000994,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetCountLimit(1,187023100)
	e1:SetCondition(c18702310.spcon)
	e1:SetCost(c18702310.drcost)
	e1:SetTarget(c18702310.sptg)
	e1:SetOperation(c18702310.spop)
	c:RegisterEffect(e1)
end
function c18702310.filter(c)
	return c:IsAbleToDeck() and c:IsSetCard(0x257)
end
function c18702310.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c18702310.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c18702310.operation2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c18702310.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SendtoDeck(g,nil,1,REASON_EFFECT)
	Duel.ShuffleDeck(tp)
	local sg=Duel.GetDecktopGroup(tp,1)
	local tc=sg:GetFirst()
	Duel.Draw(tp,1,REASON_EFFECT)
	if tc then
		Duel.ConfirmCards(1-tp,tc)
		Duel.ShuffleHand(tp)
	end
end
function c18702310.cfilter(c,tp)
	return c:IsSetCard(0x257) and c:IsType(TYPE_MONSTER) and c:IsControler(tp) and c:GetPreviousControler()==tp
end
function c18702310.filter2(c,e,tp)
	return c:IsSetCard(0x257) and c:GetLevel()<=4 and c:IsCanBeSpecialSummoned(e,257,tp,false,false)
end
function c18702310.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c18702310.cfilter,1,nil,tp) and bit.band(r,REASON_EFFECT)~=0
		and re:GetHandler():IsSetCard(0x257)
end
function c18702310.drfilter(c)
	return c:IsSetCard(0x257) and c:IsType(TYPE_MONSTER) and not c:IsPublic()
end
function c18702310.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return ep==tp and eg:IsExists(c18702310.drfilter,1,nil) end
	local g=eg:Filter(c18702310.drfilter,nil)
	if g:GetCount()==1 then
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local sg=g:Select(tp,1,1,nil)
		Duel.ConfirmCards(1-tp,sg)
		Duel.ShuffleHand(tp)
	end
end
function c18702310.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetControler()==tp and chkc:GetLocation()==LOCATION_HAND+LOCATION_GRAVE and c18702310.filter2(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c18702310.filter2,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,2,0,0)
end
function c18702310.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c18702310.filter2,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,257,tp,tp,false,false,POS_FACEUP)
	end
end
