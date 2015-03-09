--LabMem No.005-闪光的压指师
function c20400015.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_PSYCHO),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c20400015.sumcost)
	e1:SetTarget(c20400015.sumtg)
	e1:SetOperation(c20400015.sumop)
	c:RegisterEffect(e1)
	if not c20400015.global_check then
		c20400015.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c20400015.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(c20400015.clear)
		Duel.RegisterEffect(ge2,0)
	end
	--search
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_REMOVE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e4:SetTarget(c20400015.thtg)
	e4:SetOperation(c20400015.thop)
	c:RegisterEffect(e4)
	if not LabMemGlobal then
		LabMemGlobal={}
		LabMemGlobal["Effects"]={}
	end
	LabMemGlobal["Effects"]["c20400015"]=e4
end
function c20400015.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if not tc:IsRace(RACE_PSYCHO) then
			c20400015[tc:GetSummonPlayer()]=false
		end
		tc=eg:GetNext()
	end
end
function c20400015.clear(e,tp,eg,ep,ev,re,r,rp)
	c20400015[0]=true
	c20400015[1]=true
end
function c20400015.sumcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return c20400015[tp] end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c20400015.splimit)
	e1:SetLabelObject(e)
	Duel.RegisterEffect(e1,tp)
end
function c20400015.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsRace(RACE_PSYCHO)
end
function c20400015.sumfilter(c,e,tp)
	return c:IsLevelBelow(4) and not c:IsType(TYPE_XYZ) and c:IsRace(RACE_PSYCHO) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c20400015.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c20400015.sumfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_HAND+LOCATION_GRAVE)
end
function c20400015.sumop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c20400015.sumfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c20400015.filter(c,e,tp)
	return c:IsSetCard(0x204) and c:IsFaceup()
end
function c20400015.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c20400015.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c20400015.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c20400015.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c20400015.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_EXTRA_ATTACK)
		e2:SetValue(1)
		if Duel.GetTurnPlayer()==tp then
			if Duel.GetCurrentPhase()~=PHASE_END then
				e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+RESET_END)
			else
				e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+RESET_END,3)
			end
		else
			e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+RESET_END,2)
		end
		tc:RegisterEffect(e2)
	end
end
