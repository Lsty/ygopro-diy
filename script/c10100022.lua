--月符·月光吞食
function c10100022.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,10100022+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c10100022.target)
	e1:SetOperation(c10100022.activate)
	c:RegisterEffect(e1)
end
function c10100022.filter1(c,e,tp)
	if c:IsType(TYPE_XYZ) then
		return c:IsSetCard(0xa10) and c:IsFaceup() and Duel.IsExistingMatchingCard(c10100022.filter2,tp,LOCATION_EXTRA,0,1,nil,c:GetRank(),e,tp)
	else
		return c:IsSetCard(0xa10) and c:IsFaceup() and Duel.IsExistingMatchingCard(c10100022.filter2,tp,LOCATION_EXTRA,0,1,nil,c:GetLevel(),e,tp)
	end
end
function c10100022.filter2(c,lv,e,tp)
	return c:GetRank()==lv and c:IsSetCard(0xa10)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c10100022.filter3(c)
	return c:IsType(TYPE_FUSION+TYPE_RITUAL+TYPE_SYNCHRO+TYPE_XYZ) and c:IsFaceup()
end
function c10100022.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c10100022.filter1(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingTarget(c10100022.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp)
		and Duel.IsExistingTarget(c10100022.filter3,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g1=Duel.SelectTarget(tp,c10100022.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g2=Duel.SelectTarget(tp,c10100022.filter3,tp,0,LOCATION_MZONE,1,1,nil)
	e:SetLabelObject(g2:GetFirst())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c10100022.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=g:GetFirst()
	local sc=g:GetNext()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) 
		or sc:IsFacedown() or not sc:IsRelateToEffect(e) then return end
	local ac=e:GetLabelObject()
	if tc==ac then tc=sc end
	if tc:IsType(TYPE_XYZ) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g1=Duel.SelectMatchingCard(tp,c10100022.filter2,tp,LOCATION_EXTRA,0,1,1,nil,tc:GetRank(),e,tp)
		local rc=g1:GetFirst()
		if rc then
			local mg=tc:GetOverlayGroup()
			if mg:GetCount()~=0 then
				Duel.Overlay(rc,mg)
			end
			Duel.Overlay(rc,Group.FromCards(tc))
			Duel.SpecialSummon(rc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
			rc:CompleteProcedure()
			local og=ac:GetOverlayGroup()
			if og:GetCount()>0 then
				Duel.SendtoGrave(og,REASON_RULE)
			end
			Duel.Overlay(rc,Group.FromCards(ac))
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g1=Duel.SelectMatchingCard(tp,c10100022.filter2,tp,LOCATION_EXTRA,0,1,1,nil,tc:GetLevel(),e,tp)
		local rc=g1:GetFirst()
		if rc then
			Duel.Overlay(rc,tc)
			Duel.SpecialSummon(rc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
			rc:CompleteProcedure()
			local og=ac:GetOverlayGroup()
			if og:GetCount()>0 then
				Duel.SendtoGrave(og,REASON_RULE)
			end
			Duel.Overlay(rc,Group.FromCards(ac))
		end
	end
end
