--神天龙-金龙
function c9991206.initial_effect(c)
	--Special Summon From Hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetRange(LOCATION_HAND)
	e1:SetTargetRange(POS_FACEUP_ATTACK,0)
	e1:SetValue(0x40000fff)
	e1:SetCondition(c9991206.spcon)
	e1:SetOperation(c9991206.spop)
	c:RegisterEffect(e1)
	--Fusion
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9991206)
	e2:SetCost(c9991206.spcost)
	e2:SetTarget(c9991206.ftg)
	e2:SetOperation(c9991206.fop)
	c:RegisterEffect(e2)
	--Xyz Limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e3:SetCondition(c9991206.xlcon)
	e3:SetValue(aux.TRUE)
	c:RegisterEffect(e3)
end
function c9991206.cfilter(c)
	return c:IsSetCard(0x46) and c:IsAbleToRemoveAsCost()
end
function c9991206.spcost(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c9991206.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local cg=Duel.SelectMatchingCard(tp,c9991206.cfilter,tp,LOCATION_GRAVE,0,1,1,nil):GetFirst()
	Duel.Remove(cg,POS_FACEUP,REASON_COST)
end
function c9991206.spfilter(c)
	return c:IsRace(RACE_WYRM) and c:IsAbleToGraveAsCost()
end
function c9991206.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9991206.spfilter,tp,LOCATION_HAND,0,1,c)
end
function c9991206.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c9991206.spfilter,tp,LOCATION_HAND,0,1,1,c)
	Duel.SendtoGrave(g,REASON_COST)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e1,true)
end
function c9991206.xlcon(e,c)
	return e:GetHandler():IsAttackPos()
end
function c9991206.filter1(c,e)
	return c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e) and c:IsAbleToDeck()
end
function c9991206.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c)) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf) and c:IsSetCard(0xfff)
end
function c9991206.ftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
		local mg1=Duel.GetMatchingGroup(c9991206.filter1,tp,0x36,0,nil,e)
		local res=Duel.IsExistingMatchingCard(c9991206.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c9991206.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c9991206.fop(e,tp,eg,ep,ev,re,r,rp)
	local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
	local mg1=Duel.GetMatchingGroup(c9991206.filter1,tp,0x36,0,nil,e)
	local sg1=Duel.GetMatchingGroup(c9991206.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c9991206.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
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
			local cn1=mat1:Filter(Card.IsLocation,nil,LOCATION_MZONE):Filter(Card.IsFacedown,nil)
			local cn2=mat1:Filter(Card.IsLocation,nil,LOCATION_HAND)
			local gr=mat1:Filter(Card.IsLocation,nil,LOCATION_GRAVE+LOCATION_REMOVED)
			local gr2=mat1:Filter(Card.IsLocation,nil,LOCATION_MZONE):Filter(Card.IsFaceup,nil)
			gr:Merge(gr2)
			if gr:GetCount()~=0 then Duel.HintSelection(gr) end
			if cn1:GetCount()~=0 then Duel.ConfirmCards(tp,cn1) Duel.ConfirmCards(1-tp,cn1) end
			if cn2:GetCount()~=0 then Duel.ConfirmCards(1-tp,cn2) end
			Duel.SendtoDeck(mat1,nil,2,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetTargetRange(1,0)
		e1:SetTarget(c9991206.splimit)
		Duel.RegisterEffect(e1,tp)
	end
end
function c9991206.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return bit.band(sumtype,SUMMON_TYPE_FUSION)==0 and c:IsLocation(LOCATION_EXTRA)
end
