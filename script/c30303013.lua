--和紗
function c30303013.initial_effect(c)
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
	e3:SetCountLimit(1,30303013)
	e3:SetTarget(c30303013.rTarget(c30303013.ritual_filter))
	e3:SetOperation(c30303013.rOperation(c30303013.ritual_filter))
	c:RegisterEffect(e3)
	--search
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(114000605,1))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCountLimit(1,30303013)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetCondition(c30303013.condition)
	e4:SetTarget(c30303013.thtarget)
	e4:SetOperation(c30303013.thoperation)
	c:RegisterEffect(e4)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,0)
	e4:SetTarget(c30303013.splimit)
	c:RegisterEffect(e4)
end
function c30303013.ritual_filter(c)
	return c:IsSetCard(0xabb) and bit.band(c:GetType(),0x81)==0x81
end
function c30303013.exmtfilter(c)
	return c:IsSetCard(0xabb) and c:IsAbleToRemove()
end
function c30303013.rFilter(c,filter,e,tp,mg)
	if (filter and not filter(c)) or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,false) then return false end
	local code=c:GetOriginalCode()
	local mt=_G["c" .. code]
	local m=mg:Filter(mt.mat_check,nil)
	local result=false
	if m:IsContains(c) then
		m:RemoveCard(c)
		result=m:CheckWithSumEqual(Card.GetRitualLevel,c:GetLevel(),1,99,c)
		m:AddCard(c)
	else
		result=m:CheckWithSumEqual(Card.GetRitualLevel,c:GetLevel(),1,99,c)
	end
	return result
end
function c30303013.rTarget(filter)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk)
			if chk==0 then
				local mg=Duel.GetRitualMaterial(tp)
			local seq=e:GetHandler():GetSequence()
	        if seq~=6 and seq~=7 then return false end
	        local tc=Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_SZONE,13-seq)
		    if tc and tc:IsCode(30303031) then
			local exmg=Duel.GetMatchingGroup(c30303013.exmtfilter,tp,LOCATION_GRAVE,0,nil)
			mg:Merge(exmg)
		    end
				return Duel.IsExistingMatchingCard(c30303013.rFilter,tp,LOCATION_HAND,0,1,nil,filter,e,tp,mg)
			end
			Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
		end
end
function c30303013.rOperation(filter)
	return	function(e,tp,eg,ep,ev,re,r,rp)
			local mg=Duel.GetRitualMaterial(tp)
			local seq=e:GetHandler():GetSequence()
	        if seq~=6 and seq~=7 then return false end
	        local tc=Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_SZONE,13-seq)
		    if tc and tc:IsCode(30303031) then
			local exmg=Duel.GetMatchingGroup(c30303013.exmtfilter,tp,LOCATION_GRAVE,0,nil)
			mg:Merge(exmg)
		    end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tg=Duel.SelectMatchingCard(tp,c30303013.rFilter,tp,LOCATION_HAND,0,1,1,nil,filter,e,tp,mg)
			if tg:GetCount()>0 then
				local tc=tg:GetFirst()
				mg:RemoveCard(tc)
				local code=tc:GetOriginalCode()
				local mt=_G["c" .. code]
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
				local mat=mg:Filter(mt.mat_check,nil):SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),1,99,tc)
				tc:SetMaterial(mat)
				Duel.ReleaseRitualMaterial(mat)
				Duel.BreakEffect()
				Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,true,false,POS_FACEUP)
				tc:CompleteProcedure()
			end
		end
end
function c30303013.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function c30303013.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.SendtoGrave(c,REASON_EFFECT)
end
function c30303013.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer() and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c30303013.filter3(c,e,tp)
	return (c:IsCode(30303031) or (c:IsSetCard(0xabb) and bit.band(c:GetType(),0x81)==0x81)) and c:IsAbleToHand()
end
function c30303013.thtarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c30303013.filter3,tp,LOCATION_DECK,0,1,nil,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND+CATEGORY_SEARCH,nil,0,tp,1)
end
function c30303013.thoperation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectMatchingCard(tp,c30303013.filter3,tp,LOCATION_DECK,0,1,1,nil)
	if sg:GetCount()>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c30303013.splimit(e,c,tp,sumtp,sumpos)
	return bit.band(sumtp,SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ
end