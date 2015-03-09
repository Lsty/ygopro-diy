--虚无 焰
function c9991002.initial_effect(c)
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
	e2:SetTarget(c9991002.sptg)
	e2:SetOperation(c9991002.spop)
	c:RegisterEffect(e2)
	if not c9991002.global_check then
		c9991002.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_LEAVE_FIELD)
		ge1:SetOperation(c9991002.regop)
		Duel.RegisterEffect(ge1,0)
	end
	--Hand Special Summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(c9991002.spproc)
	e3:SetOperation(c9991002.spprocop)
	c:RegisterEffect(e3)
	--Guarding
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetTarget(c9991002.gtg)
	e4:SetOperation(c9991002.gop)
	c:RegisterEffect(e4)
	--Pendulum Scale Change
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_PZONE)
	e5:SetCode(EFFECT_CHANGE_RSCALE)
	e5:SetTargetRange(LOCATION_SZONE,0)
	e5:SetCondition(c9991002.sclcon)
	e5:SetTarget(c9991002.scltg)
	e5:SetValue(8)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_CHANGE_LSCALE)
	c:RegisterEffect(e6)
end
function c9991002.actfil(c,tp)
	return c:IsSetCard(0xeff) and c:IsPreviousPosition(POS_FACEUP) and c:IsReason(REASON_DESTROY) and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_MZONE)
end
function c9991002.regop(e,tp,eg,ep,ev,re,r,rp)
	local sf=0
	if eg:IsExists(c9991002.actfil,1,nil,0) and Duel.GetFlagEffect(0,9991000)==0 then sf=sf+1 end
	if eg:IsExists(c9991002.actfil,1,nil,1) and Duel.GetFlagEffect(1,9991000)==0 then sf=sf+2 end
	if sf==0 then return end
	Duel.RaiseEvent(eg,9991000,e,r,rp,ep,sf)
	if sf~=2 then Duel.RegisterFlagEffect(0,9991000,RESET_CHAIN,0,1) end
	if sf~=1 then Duel.RegisterFlagEffect(1,9991000,RESET_CHAIN,0,1) end
end
function c9991002.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,true) and bit.band(bit.rshift(ev,tp),1)~=0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9991002.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() if c:IsRelateToEffect(e) then Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) end
end
function c9991002.spproc(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and Duel.GetMatchingGroupCount(c9991002.exfilter,c:GetControler(),LOCATION_MZONE,0,nil)>0
end
function c9991002.exfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xeff)
end
function c9991002.spprocop(e,tp,eg,ep,ev,re,r,rp)
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
function c9991002.sumlimit(e,c,sump,sumtype,sumpos,targetp,sumtp)
	return c:IsLocation(LOCATION_HAND) and sumtype~=SUMMON_TYPE_PENDULUM
end
function c9991002.gtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c9991002.exfilter(chkc) and e:GetHandler()~=chkc end
	if chk==0 then return Duel.IsExistingTarget(c9991002.exfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c9991002.exfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c9991002.gop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget() local c=e:GetHandler()
	if not (c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup()) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(9991002,0))
	e2:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetValue(c9991002.efilter)
	tc:RegisterEffect(e2)
	Duel.Destroy(c,REASON_EFFECT)
end
function c9991002.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c9991002.sclcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_SZONE,13-e:GetHandler():GetSequence())
	return tc and tc:IsSetCard(0xeff)
end
function c9991002.scltg(e,c)
	return c==Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_SZONE,13-e:GetHandler():GetSequence())
end
