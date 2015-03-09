--人之幻想 女神天子
function c6668628.initial_effect(c)
	c:SetUniqueOnField(1,0,6668628)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,6668625,c6668628.ffilter,1,true,true)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,6668628)
	e1:SetTarget(c6668628.target)
	e1:SetOperation(c6668628.activate)
	c:RegisterEffect(e1)
	--Immunity
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetTarget(c6668628.tg)
	e2:SetValue(c6668628.efilter)
	c:RegisterEffect(e2)
end
function c6668628.ffilter(c)
	return c:IsSetCard(0x743) and c:IsType(TYPE_RITUAL+TYPE_MONSTER)
end
function c6668628.filter(c,e,tp,m)
	if c:IsType(TYPE_RITUAL+TYPE_MONSTER) and c:IsSetCard(0x743)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,false) then return true end
	if c.mat_filter then
		m=m:Filter(c.mat_filter,nil)
	end
	return m:CheckWithSumEqual(Card.GetRitualLevel,c:GetLevel(),1,99,c) and c:IsType(TYPE_RITUAL+TYPE_MONSTER) and c:IsSetCard(0x743)
end
function c6668628.matfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c6668628.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
		local mg=Duel.GetMatchingGroup(c6668628.matfilter,tp,LOCATION_DECK,0,nil)
		return Duel.IsExistingMatchingCard(c6668628.filter,tp,LOCATION_HAND,0,1,nil,e,tp,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c6668628.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local mg=Duel.GetMatchingGroup(c6668628.matfilter,tp,LOCATION_DECK,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,c6668628.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp,mg)
	if tg:GetCount()>0 then
		local tc=tg:GetFirst()
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,nil)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local mat=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),1,99,tc)
		tc:SetMaterial(mat)
		Duel.SendtoGrave(mat,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,true,false,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function c6668628.tg(e,c)
	return c:IsSetCard(0x743) and c:IsType(TYPE_MONSTER)
end
function c6668628.efilter(e,re,rp)
	if not (re:IsActiveType(TYPE_MONSTER) and re:IsHasType(0x7e0)) then return false end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return true end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	return not g:IsContains(e:GetHandler())
end