--雪菜
function c30303031.initial_effect(c)
	--pendulum summon
	aux.AddPendulumProcedure(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(65518099,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1,30303031)
	e3:SetTarget(c30303031.target)
	e3:SetOperation(c30303031.operation)
	c:RegisterEffect(e3)
	--search
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(114000605,1))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCountLimit(1,30303031)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetCondition(c30303031.condition)
	e4:SetTarget(c30303031.thtarget)
	e4:SetOperation(c30303031.thoperation)
	c:RegisterEffect(e4)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,0)
	e4:SetTarget(c30303031.splimit)
	c:RegisterEffect(e4)
end
function c30303031.filter(c,e)
	return c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e)
end
function c30303031.filter1(c,e)
	return c:IsCanBeFusionMaterial() and c:IsAbleToRemove() and not c:IsImmuneToEffect(e)
end
function c30303031.filter2(c,e,tp,m,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0xabb) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
		and c:CheckFusionMaterial(m,nil,chkf)
end
function c30303031.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer() and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c30303031.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
		local mg1=Duel.GetMatchingGroup(c30303031.filter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,e)
	    local seq=e:GetHandler():GetSequence()
	    if seq~=6 and seq~=7 then return false end
	    local tc=Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_SZONE,13-seq)
		if tc and tc:IsCode(30303013) then
			local sg=Duel.GetMatchingGroup(c30303031.filter1,tp,LOCATION_GRAVE,0,nil,e)
			mg1:Merge(sg)
		end
		local res=Duel.IsExistingMatchingCard(c30303031.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				res=Duel.IsExistingMatchingCard(c30303031.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c30303031.operation(e,tp,eg,ep,ev,re,r,rp)
	local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
	local mg1=Duel.GetMatchingGroup(c30303031.filter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,e)
	local seq=e:GetHandler():GetSequence()
	    if seq~=6 and seq~=7 then return false end
	    local tc=Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_SZONE,13-seq)
	if tc and tc:IsCode(30303013) then
		local sg=Duel.GetMatchingGroup(c30303031.filter1,tp,LOCATION_GRAVE,0,nil,e)
		mg1:Merge(sg)
	end
	local sg1=Duel.GetMatchingGroup(c30303031.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		sg2=Duel.GetMatchingGroup(c30303031.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,chkf)
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
			local tg=mat1:GetFirst()
			while tg do
				if tg:IsLocation(LOCATION_GRAVE) then
					Duel.Remove(tg,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
				else
					Duel.SendtoGrave(tg,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
				end
				tg=mat1:GetNext()
			end
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
function c30303031.filterb(c,fc)
	if c:IsHasEffect(EFFECT_FORBIDDEN) or not c:IsAbleToHand() then return false end
	if Duel.IsExistingMatchingCard(c30303031.filtera,tp,LOCATION_EXTRA,0,1,nil,tp) then
	for i=1,fc.material_count do
		if c:IsCode(fc.material[i]) then return true end
	end
	end
	return c:IsCode(30303013) and c:IsAbleToHand()
end
function c30303031.filtera(c,tp)
	return c.material_count and Duel.IsExistingMatchingCard(c30303031.filterb,tp,LOCATION_DECK,0,1,nil,c) and c:IsSetCard(0xabb)
end
function c30303031.thtarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c30303031.filtera,tp,LOCATION_EXTRA,0,1,nil,tp) or Duel.IsExistingMatchingCard(c30303031.filterc,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND+CATEGORY_SEARCH,nil,0,tp,1)
end
function c30303031.thoperation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local cg=Duel.SelectMatchingCard(tp,c30303031.filtera,tp,LOCATION_EXTRA,0,1,1,nil,tp)
	Duel.ConfirmCards(1-tp,cg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c30303031.filterb,tp,LOCATION_DECK,0,1,1,nil,cg:GetFirst())
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
end
end
function c30303031.splimit(e,c,tp,sumtp,sumpos)
	return bit.band(sumtp,SUMMON_TYPE_XYZ)==SUMMON_TYPE_SYNCHRO
end
