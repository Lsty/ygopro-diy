--AE
function c3033034.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c3033034.target)
	e1:SetOperation(c3033034.activate)
	c:RegisterEffect(e1)
end
function c3033034.cfilter(c,e,tp)
	return c:IsCode(3033031) or c:IsCode(3033032) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c3033034.filter(c)
	return  c:GetLevel()==4 and c:IsFaceup() and c:IsRace(RACE_FAIRY)
end
function c3033034.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingMatchingCard(c3033034.cfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
		and Duel.IsExistingTarget(c3033034.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c3033034.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c3033034.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c3033034.cfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local sc=g:GetFirst()
	if sc then
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		Duel.Overlay(sc,Group.FromCards(tc))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
	local op=0
	if tc:IsRace(RACE_FAIRY) then op=Duel.SelectOption(tp,aux.Stringid(3033034,1),aux.Stringid(3033034,2)) end
	if op==0 then
	Duel.Recover(tp,500,REASON_EFFECT)
	else
	local sg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if sg:GetCount()>0 then
		Duel.ChangePosition(sg,POS_FACEUP_ATTACK,0,POS_FACEUP_ATTACK,0)
		local tc=sg:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_MUST_ATTACK)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			tc=sg:GetNext()
		end
		local be=Effect.CreateEffect(c)
		be:SetType(EFFECT_TYPE_FIELD)
		be:SetCode(EFFECT_CANNOT_EP)
		be:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		be:SetTargetRange(0,1)
		be:SetCondition(c3033034.becon)
		be:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(be,tp)
	end
    end
		sc:CompleteProcedure()
	end
end
function c3033034.befilter(c)
	return c:GetFlagEffect(3033034)~=0 and c:IsAttackable()
end
function c3033034.becon(e)
	return Duel.IsExistingMatchingCard(c3033034.befilter,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil)
end