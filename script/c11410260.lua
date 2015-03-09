---喰-欲望
function c11410260.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c11410260.target)
	e1:SetOperation(c11410260.activate)
	c:RegisterEffect(e1)
end
function c11410260.filter1(c,e,tp)
	local rank=c:GetLevel()+1
	if c:IsType(TYPE_XYZ) then
		rank=c:GetRank()+1
	end
	return c:IsFaceup() and c:IsSetCard(0x475)
		and Duel.IsExistingMatchingCard(c11410260.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,rank)
end
function c11410260.filter2(c,e,tp,rank)
	return c:GetRank()==rank and c:IsSetCard(0x475)
		and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c11410260.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c11410260.filter1(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingTarget(c11410260.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp)end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c11410260.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c11410260.cfilter(c,rank)
	local lv=c:GetLevel()
	if c:IsType(TYPE_XYZ) then
		lv=c:GetRank()
	end
	return lv>rank
end
function c11410260.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	local rank=tc:GetLevel()+1
	if tc:IsType(TYPE_XYZ) then
		rank=tc:GetRank()+1
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c11410260.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,rank)
	local sc=g:GetFirst()
	if sc then
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		Duel.Overlay(sc,Group.FromCards(tc))
		Duel.SpecialSummon(sc,0,tp,tp,true,false,POS_FACEUP)
		sc:CompleteProcedure()
		if Duel.IsExistingMatchingCard(c11410260.cfilter,tp,0,LOCATION_MZONE,1,nil,sc:GetRank()) then
			Duel.BreakEffect()
			local g1=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_DECK,0,nil,0x475)
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(11410260,0))
			local mg2=g1:Select(tp,1,2,nil)
			Duel.Overlay(sc,mg2)
			Duel.ShuffleDeck(tp)
		end
	end
end