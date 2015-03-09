--命运石之门的选择
function c20400025.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c20400025.target)
	e1:SetOperation(c20400025.activate)
	c:RegisterEffect(e1)
end
function c20400025.filter1(c,e)
	return c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e) and c:IsAbleToRemove()
end
function c20400025.filter2(c,e,tp,m)
	return c:IsSetCard(0x204) and c:IsType(TYPE_FUSION) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,PLAYER_NONE,false,false) and c:CheckFusionMaterial(m)
end
function c20400025.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetMatchingGroup(c20400025.filter1,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_GRAVE,nil,e)
		return Duel.IsExistingMatchingCard(c20400025.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg)
	end
	e:GetHandler():SetTurnCounter(0)
end
function c20400025.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=Duel.GetMatchingGroup(c20400025.filter1,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_GRAVE,nil,e)
	local sg=Duel.GetMatchingGroup(c20400025.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg)
	if sg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		Duel.ConfirmCards(1-tp,tc)
		local code=tc:GetCode()
		local mat=Duel.SelectFusionMaterial(tp,tc,mg)
		local fg=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_EXTRA,0,nil,code)
		local tc=fg:GetFirst()
		while tc do
			tc:SetMaterial(mat)
			tc=fg:GetNext()
		end
		Duel.Remove(mat,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
		--special summon
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetCountLimit(1)
		e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,2)
		e1:SetOperation(c20400025.proc)
		e1:SetLabel(code)
		e1:SetLabelObject(e)
		Duel.RegisterEffect(e1,tp)
	end
end
function c20400025.procfilter(c,code,e,tp)
	return c:IsCode(code) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
end
function c20400025.proc(e,tp,eg,ep,ev,re,r,rp)
	if tp~=Duel.GetTurnPlayer() then return end
	local c=e:GetHandler()
	local code=e:GetLabel()
	local tc=Duel.GetFirstMatchingCard(c20400025.procfilter,tp,LOCATION_EXTRA,0,nil,code,e,tp)
	if not tc then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then
		Duel.SendtoGrave(tc,REASON_EFFECT)
		tc:CompleteProcedure()
	else
		Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		tc:CompleteProcedure()
	end
end