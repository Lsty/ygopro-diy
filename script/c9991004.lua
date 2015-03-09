--虚无铳士 麻美
function c9991004.initial_effect(c)
	aux.AddPendulumProcedure(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Pendulum Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(9991000)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTarget(c9991004.sptg)
	e2:SetOperation(c9991004.spop)
	c:RegisterEffect(e2)
	if not c9991004.global_check then
		c9991004.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_LEAVE_FIELD)
		ge1:SetOperation(c9991004.regop)
		Duel.RegisterEffect(ge1,0)
	end
	--Hand Special Summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(c9991004.spproc)
	e3:SetOperation(c9991004.spprocop)
	c:RegisterEffect(e3)
	--Position Change
	local e4=Effect.CreateEffect(c)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCategory(CATEGORY_POSITION+CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(c9991004.condition)
	e4:SetTarget(c9991004.pctg)
	e4:SetOperation(c9991004.pcop)
	c:RegisterEffect(e4)
end
function c9991004.actfil(c,tp)
	return c:IsSetCard(0xeff) and c:IsPreviousPosition(POS_FACEUP) and c:IsReason(REASON_DESTROY) and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_MZONE)
end
function c9991004.regop(e,tp,eg,ep,ev,re,r,rp)
	local sf=0
	if eg:IsExists(c9991004.actfil,1,nil,0) and Duel.GetFlagEffect(0,9991000)==0 then sf=sf+1 end
	if eg:IsExists(c9991004.actfil,1,nil,1) and Duel.GetFlagEffect(1,9991000)==0 then sf=sf+2 end
	if sf==0 then return end
	Duel.RaiseEvent(eg,9991000,e,r,rp,ep,sf)
	if sf~=2 then Duel.RegisterFlagEffect(0,9991000,RESET_CHAIN,0,1) end
	if sf~=1 then Duel.RegisterFlagEffect(1,9991000,RESET_CHAIN,0,1) end
end
function c9991004.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,true) and bit.band(bit.rshift(ev,tp),1)~=0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9991004.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(9991001,0))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetCountLimit(1)
		e1:SetValue(c9991001.indval)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
		Duel.SpecialSummonComplete()
	end
end
function c9991004.indval(e,re,r,rp)
	return bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0
end
function c9991004.spproc(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and Duel.GetMatchingGroupCount(c9991004.exfilter,c:GetControler(),LOCATION_MZONE,0,nil)>=2
end
function c9991004.exfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xeff)
end
function c9991004.spprocop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c9991001.sumlimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c9991004.sumlimit(e,c,sump,sumtype,sumpos,targetp,sumtp)
	return c:IsLocation(LOCATION_HAND) and sumtype~=SUMMON_TYPE_PENDULUM
end
function c9991004.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xeff) and (c:GetSequence()==6 or c:GetSequence()==7)
end
function c9991004.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(c9991004.filter,tp,LOCATION_SZONE,0,nil)>0
end
function c9991004.pctg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TURE,tp,0,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(aux.TURE,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,sg,sg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c9991004.pcop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(aux.TURE,tp,0,LOCATION_MZONE,nil) local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or sg:GetCount()==0 then return end
	if Duel.ChangePosition(sg,POS_FACEUP_DEFENCE,POS_FACEUP_DEFENCE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,true)~=0
		then Duel.BreakEffect() Duel.Destroy(c,REASON_EFFECT) end
end
