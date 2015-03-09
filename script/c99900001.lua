--自伤者之殇
function c99900001.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c99900001.target)
	e1:SetOperation(c99900001.activate)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CHAIN_UNIQUE)
	e2:SetCode(EVENT_DAMAGE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c99900001.cost)
	e2:SetCondition(c99900001.recon)
	e2:SetTarget(c99900001.rectg)
	e2:SetOperation(c99900001.recop)
	c:RegisterEffect(e2)
end
function c99900001.mfilter1(c,e)
	return (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:GetLevel()>0 and not c:IsImmuneToEffect(e) and c:IsReleasable()
end
function c99900001.mfilter2(c,e)
	return c:IsFaceup() and c:GetLevel()>0 and not c:IsImmuneToEffect(e) and c:IsReleasable()
end
function c99900001.mfilter3(c)
	return c:IsHasEffect(EFFECT_EXTRA_RITUAL_MATERIAL) and c:IsAbleToRemove()
end
function c99900001.get_material(e,tp)
	local g1=Duel.GetMatchingGroup(c99900001.mfilter1,tp,LOCATION_MZONE+LOCATION_HAND,0,nil,e)
	local g2=Duel.GetMatchingGroup(c99900001.mfilter3,tp,LOCATION_GRAVE,0,nil)
	g1:Merge(g2)
	return g1
end
function c99900001.get_material1(e,tp)
	local g1=Duel.GetMatchingGroup(c99900001.mfilter2,tp,LOCATION_MZONE,0,nil,e)
	return g1
end
function c99900001.get_material2(e,tp)
	local g1=Duel.GetMatchingGroup(c99900001.mfilter1,tp,LOCATION_HAND,0,nil,e)
	local g2=Duel.GetMatchingGroup(c99900001.mfilter3,tp,LOCATION_GRAVE,0,nil)
	g1:Merge(g2)
	return g1
end
function c99900001.filter(c,e,tp,m)
	if bit.band(c:GetType(),0x81)~=0x81 or not c:IsSetCard(0x999)
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,false) then return false end
	if m:IsContains(c) then
		m:RemoveCard(c)
		result=m:GetCount()>0
		m:AddCard(c)
	else
		result=m:GetCount()>0
	end
	return result
end
function c99900001.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return false end
		local mg=c99900001.get_material(e,tp)
		local mg1=c99900001.get_material1(e,tp)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then
			return Duel.IsExistingMatchingCard(c99900001.filter,tp,LOCATION_HAND,0,1,nil,e,tp,mg1)
		elseif Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			return Duel.IsExistingMatchingCard(c99900001.filter,tp,LOCATION_HAND,0,1,nil,e,tp,mg)
		end
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c99900001.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
	local mg=c99900001.get_material(e,tp)
	local mg1=c99900001.get_material1(e,tp)
	local mg2=c99900001.get_material2(e,tp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=Duel.SelectMatchingCard(tp,c99900001.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp,mg)
		if tg:GetCount()>0 then
			local tc=tg:GetFirst()
			mg:RemoveCard(tc)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local mat=mg:Select(tp,1,99,tc)
			tc:SetMaterial(mat)
			Duel.ReleaseRitualMaterial(mat)
			local ct=tc:GetOriginalLevel()
			local cf=mat:GetSum(Card.GetRitualLevel,tc)
			if ct>cf then
				Duel.BreakEffect()
				Duel.Damage(tp,(ct-cf)*500,REASON_EFFECT)
			end
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,true,false,POS_FACEUP)
			tc:CompleteProcedure()
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=Duel.SelectMatchingCard(tp,c99900001.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp,mg1)
		if tg:GetCount()>0 then
			local tc=tg:GetFirst()
			mg:RemoveCard(tc)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local mat=mg1:Select(tp,1,99,tc)
			if Duel.SelectYesNo(tp,aux.Stringid(99900001,0)) then
				local mat1=mg2:Select(tp,1,99,tc)
				mat:Merge(mat1)
				tc:SetMaterial(mat)
				Duel.ReleaseRitualMaterial(mat)
				local ct=tc:GetOriginalLevel()
				local cf=mat:GetSum(Card.GetRitualLevel,tc)
				if ct>cf then
					Duel.BreakEffect()
					Duel.Damage(tp,(ct-cf)*500,REASON_EFFECT)
				end
				Duel.BreakEffect()
				Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,true,false,POS_FACEUP)
				tc:CompleteProcedure()
			else
				tc:SetMaterial(mat)
				Duel.ReleaseRitualMaterial(mat)
				local ct=tc:GetOriginalLevel()
				local cf=mat:GetSum(Card.GetRitualLevel,tc)
				if ct>cf then
					Duel.BreakEffect()
					Duel.Damage(tp,(ct-cf)*500,REASON_EFFECT)
				end
				Duel.BreakEffect()
				Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,true,false,POS_FACEUP)
				tc:CompleteProcedure()
			end
		end
	end
end
function c99900001.rfilter1(c)
	return c:IsSetCard(0x999) and c:IsAbleToRemoveAsCost()
end
function c99900001.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,99900001)==0
		and Duel.IsExistingMatchingCard(c99900001.rfilter1,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c99900001.rfilter1,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	Duel.RegisterFlagEffect(tp,99900001,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c99900001.recon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and e:GetHandler():GetTurnID()~=Duel.GetTurnCount()
end
function c99900001.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c99900001.recop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,e:GetHandler())
	end
end