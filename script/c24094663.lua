--初之辉
function c24094663.initial_effect(c)
function Auxiliary.AddXyzProcedure(c,f,lv,ct,alterf,desc,maxct,op)
	if c.xyz_filter==nil then
		local code=c:GetOriginalCode()
		local mt=_G["c" .. code]
		if f then
			mt.xyz_filter=function(mc) return f(mc) and mc:IsXyzLevel(c,lv) end
		else
			mt.xyz_filter=function(mc) return mc:IsXyzLevel(c,lv) end
		end
		mt.xyz_count=ct
		if not maxct then maxct=ct end
		mt.xyz_maxcount=maxct
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	if not maxct then maxct=ct end
	if alterf then
		e1:SetCondition(Auxiliary.XyzCondition2(f,lv,ct,maxct,alterf,desc,op))
		e1:SetOperation(Auxiliary.XyzOperation2(f,lv,ct,maxct,alterf,desc,op))
	else
		e1:SetCondition(Auxiliary.XyzCondition(f,lv,ct,maxct))
		e1:SetOperation(Auxiliary.XyzOperation(f,lv,ct,maxct))
	end
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
end
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c24094663.target)
	e1:SetOperation(c24094663.activate)
	c:RegisterEffect(e1)
end
function c24094663.filter0(c,tc)
	return c:IsCanBeXyzMaterial(tc) and tc.xyz_filter(c) and c:IsLocation(LOCATION_MZONE)
end
function c24094663.filter1(c,tc)
	return c:IsCanBeXyzMaterial(tc) and tc.xyz_filter(c)
end
function c24094663.filter2(c,e,tp)
	return c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c24094663.mfilter(c,e,tp,mg)
	return c:IsXyzSummonable(mg) and (Duel.GetLocationCount(e:GetOwner(),LOCATION_MZONE)>0 or mg:IsExists(c24094663.lfilter,1,nil,e,tp,c))
end
function c24094663.lfilter(c,e,tp,mc)
	return c:IsLocation(LOCATION_MZONE) and c:GetControler()==e:GetOwner() and mc.xyz_filter(c)
end
function c24094663.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetMatchingGroup(nil,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,e)
	local exg=Duel.GetMatchingGroup(c24094663.filter2,tp,LOCATION_EXTRA,0,nil,e,tp)
	if chk==0 then
		return exg:IsExists(c24094663.mfilter,1,nil,e,tp,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c24094663.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg1=Duel.GetMatchingGroup(nil,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,e)
	local exg=Duel.GetMatchingGroup(c24094663.filter2,tp,LOCATION_EXTRA,0,nil,e,tp)
	local sg=exg:Filter(c24094663.mfilter,nil,e,tp,mg1)
	if sg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
			local mg=mg1:Filter(c24094663.filter1,nil,tc):Select(tp,tc.xyz_count,tc.xyz_maxcount,nil)
			Duel.XyzSummon(tp,tc,mg)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
			local mg0=mg1:Filter(c24094663.filter0,nil,tc):Select(tp,1,1,nil)
			m1:RemoveCard(m0:GetFirst())
			local mg=mg1:Filter(c24094663.filter1,nil,tc):Select(tp,tc.xyz_count-1,tc.xyz_maxcount-1,nil)
			mg:Merge(mg0)
			Duel.XyzSummon(tp,tc,mg)
		end
	end
end