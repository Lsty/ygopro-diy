--义妹·爱匹莉娅
function c74700030.initial_effect(c)
	--pendulum summon
	aux.AddPendulumProcedure(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(74700030,3))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--fusion effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(74700030,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_STANDBY_PHASE+0x1c0)
	e2:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e2:SetCountLimit(1,74700030)
	e2:SetCost(c74700030.cost)
	e2:SetTarget(c74700030.sptg1)
	e2:SetOperation(c74700030.spop1)
	c:RegisterEffect(e2)
	--pemdilum effect
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(74700030,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMING_STANDBY_PHASE+0x1c0)
	e3:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e3:SetCountLimit(1,74700031)
	e3:SetCost(c74700030.cost)
	e3:SetCondition(c74700030.con)
	e3:SetOperation(c74700030.spop2)
	c:RegisterEffect(e3)
end
function c74700030.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c74700030.ffilter1(c,e)
	return c:IsSetCard(0x747) and c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e)
end
function c74700030.ffilter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c74700030.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
		local mg1=Duel.GetMatchingGroup(c74700030.ffilter1,tp,LOCATION_HAND+LOCATION_MZONE,0,e:GetHandler(),e)
		local res=Duel.IsExistingMatchingCard(c74700030.ffilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp):Filter(c74700030.ffilter1,nil)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c74700030.ffilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c74700030.spop1(e,tp,eg,ep,ev,re,r,rp)
	local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
	local mg1=Duel.GetMatchingGroup(c74700030.ffilter1,tp,LOCATION_HAND+LOCATION_MZONE,0,e:GetHandler(),e)
	local sg1=Duel.GetMatchingGroup(c74700030.ffilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		local mg2=fgroup(ce,e,tp):Filter(c74700030.ffilter1,nil)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c74700030.ffilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			tc:SetMaterial(mat1)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
end
function c74700030.confilter(c,e,tp,lscale,rscale)
	local lv=c:GetLevel()
	return (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsType(TYPE_PENDULUM)
		and lv>lscale and lv<rscale and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_PENDULUM,tp,false,false)
end
function c74700030.con(e)
	local c=e:GetHandler()
	local tp=c:GetControler()
	local lpz=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local rpz=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	if lpz==nil or rpz==nil then return false end
	local lscale=lpz:GetLeftScale()
	local rscale=rpz:GetRightScale()
	if lscale>rscale then lscale,rscale=rscale,lscale end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return false
	else return Duel.IsExistingMatchingCard(c74700030.confilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,e:GetHandler(),e,tp,lscale,rscale)
	end
end
function c74700030.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lpz=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local rpz=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	if lpz==nil or rpz==nil then return false end
	local lscale=lpz:GetLeftScale()
	local rscale=rpz:GetRightScale()
	if lscale>rscale then lscale,rscale=rscale,lscale end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return false end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c74700030.confilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,ft,e:GetHandler(),e,tp,lscale,rscale)
	local pg=Group.FromCards(lpz,rpz)
	Duel.HintSelection(pg)
	Duel.SpecialSummon(sg,SUMMON_TYPE_PENDULUM,tp,tp,false,false,POS_FACEUP)
end