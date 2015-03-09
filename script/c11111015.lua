--魔王降临
function c11111015.initial_effect(c)
    --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c11111015.condition)
	e1:SetTarget(c11111015.target)
	e1:SetOperation(c11111015.activate)
	c:RegisterEffect(e1)
	--material
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11111015,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CHAIN_UNIQUE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,11111015+EFFECT_COUNT_CODE_DUEL)
	e2:SetCondition(c11111015.matcon)
	e2:SetTarget(c11111015.mattg)
	e2:SetOperation(c11111015.matop)
	c:RegisterEffect(e2)
end
function c11111015.condition(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
end
function c11111015.filter(c,e,tp)
	return c:GetLevel()==8 and c:IsCanBeEffectTarget(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c11111015.xyzfilter(c,mg)
	if c.xyz_count~=2 then return false end
	return c:IsXyzSummonable(mg) and c:IsRace(RACE_FAIRY)
end
function c11111015.mfilter1(c,exg)
	return exg:IsExists(c11111015.mfilter2,1,nil,c)
end
function c11111015.mfilter2(c,mc)
	return c.xyz_filter(mc)
end
function c11111015.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local mg=Duel.GetMatchingGroup(c11111015.filter,tp,LOCATION_GRAVE,0,nil,e,tp)
	if chk==0 then return (not Duel.IsPlayerAffectedByEffect(tp,23516703) or c23516703[tp]==0)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and mg:GetCount()>1
		and Duel.IsExistingMatchingCard(c11111015.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,mg) end
	local exg=Duel.GetMatchingGroup(c11111015.xyzfilter,tp,LOCATION_EXTRA,0,nil,mg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg1=mg:FilterSelect(tp,c11111015.mfilter1,1,1,nil,exg)
	local tc1=sg1:GetFirst()
	local exg2=exg:Filter(c11111015.mfilter2,nil,tc1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg2=mg:FilterSelect(tp,c11111015.mfilter1,1,1,tc1,exg2)
	sg1:Merge(sg2)
	Duel.SetTargetCard(sg1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg1,2,0,0)
end
function c11111015.filter2(c,e,tp)
	return c:IsRelateToEffect(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c11111015.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,23516703) and c23516703[tp]>0 then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c11111015.filter2,nil,e,tp)
	if g:GetCount()<2 then return end
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	Duel.BreakEffect()
	local xyzg=Duel.GetMatchingGroup(c11111015.xyzfilter,tp,LOCATION_EXTRA,0,nil,g)
	if xyzg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
		Duel.XyzSummon(tp,xyz,g)
	end
end
function c11111015.matcon(e,tp,eg,ep,ev,re,r,rp)
    local tc=eg:GetFirst()
    return tc:IsFaceup() and tc:IsRankAbove(9) and tc:GetSummonType()==SUMMON_TYPE_XYZ and tc:IsControler(tp)
end
function c11111015.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return false end
	if chk==0 then return eg:GetFirst():IsCanBeEffectTarget(e) end
	Duel.SetTargetCard(eg)
end	
function c11111015.matop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and c:IsRelateToEffect(e) then
		Duel.Overlay(tc,Group.FromCards(c))
	end
end
	