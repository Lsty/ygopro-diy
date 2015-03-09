--樱花飞散的梦
function c116811185.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,116811185+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c116811185.plcost)
	e1:SetTarget(c116811185.pltg)
	e1:SetOperation(c116811185.plop)
	c:RegisterEffect(e1)
end
function c116811185.plfilter(c)
	return c:IsSetCard(0x3e2) and c:IsAbleToGraveAsCost()
end
function c116811185.plcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)==0
		and Duel.IsExistingMatchingCard(c116811185.plfilter,tp,LOCATION_SZONE,0,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(c116811185.plfilter,tp,LOCATION_SZONE,0,e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c116811185.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c116811185.filter(c,e,tp)
	return c:IsLevelBelow(4) and c:IsSetCard(0x3e2) and c:IsType(TYPE_MONSTER)
end
function c116811185.pltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c116811185.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,LOCATION_GRAVE)
end
function c116811185.plop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if ft<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c116811185.filter,tp,LOCATION_GRAVE,0,ft,ft,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		while tc do
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fc0000)
			e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
			tc:RegisterEffect(e1)
			tc=g:GetNext()
		end
		Duel.Damage(tp,g:GetCount()*500,REASON_EFFECT)
	end
end
function c116811185.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x44e0)
end