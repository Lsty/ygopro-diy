--虚无弓士 圆
function c9991000.initial_effect(c)
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
	e2:SetTarget(c9991000.sptg)
	e2:SetOperation(c9991000.spop)
	c:RegisterEffect(e2)
	if not c9991000.global_check then
		c9991000.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_LEAVE_FIELD)
		ge1:SetOperation(c9991000.regop)
		Duel.RegisterEffect(ge1,0)
	end
	--Multiplied Attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EXTRA_ATTACK)
	e3:SetValue(c9991000.maval)
	c:RegisterEffect(e3)
	--Pendulum Scale Change
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCode(EFFECT_CHANGE_RSCALE)
	e4:SetTargetRange(LOCATION_SZONE,0)
	e4:SetCondition(c9991000.sclcon)
	e4:SetTarget(c9991000.scltg)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CHANGE_LSCALE)
	c:RegisterEffect(e5)
	--Synchro Limit
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_SYNCHRO_MATERIAL_CUSTOM)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e6:SetValue(1)
	e6:SetTarget(c9991000.syntg)
	e6:SetOperation(c9991000.synop)
	c:RegisterEffect(e6)
	--Power Up
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetCategory(CATEGORY_ATKCHANGE)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1)
	e7:SetTarget(c9991000.putg)
	e7:SetOperation(c9991000.puop)
	c:RegisterEffect(e7)
end
function c9991000.actfil(c,tp)
	return c:IsSetCard(0xeff) and c:IsPreviousPosition(POS_FACEUP) and c:IsReason(REASON_DESTROY) and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_MZONE)
end
function c9991000.regop(e,tp,eg,ep,ev,re,r,rp)
	local sf=0
	if eg:IsExists(c9991000.actfil,1,nil,0) and Duel.GetFlagEffect(0,9991000)==0 then sf=sf+1 end
	if eg:IsExists(c9991000.actfil,1,nil,1) and Duel.GetFlagEffect(1,9991000)==0 then sf=sf+2 end
	if sf==0 then return end
	Duel.RaiseEvent(eg,9991000,e,r,rp,ep,sf)
	if sf~=2 then Duel.RegisterFlagEffect(0,9991000,RESET_CHAIN,0,1) end
	if sf~=1 then Duel.RegisterFlagEffect(1,9991000,RESET_CHAIN,0,1) end
end
function c9991000.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,true) and bit.band(bit.rshift(ev,tp),1)~=0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9991000.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP) end
end
function c9991000.maval(e,c)
	return Duel.GetMatchingGroupCount(c9991000.pufilter,c:GetControler(),LOCATION_MZONE,0,nil)-1
end
function c9991000.sclcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_SZONE,13-e:GetHandler():GetSequence())
	return tc and tc:IsSetCard(0xeff)
end
function c9991000.scltg(e,c)
	return c==Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_SZONE,13-e:GetHandler():GetSequence())
end
c9991000.tuner_filter=aux.FilterBoolFunction(Card.IsSetCard,0xeff)
function c9991000.synfilter(c,syncard,tuner,f)
	return c:IsFaceup() and c:IsNotTuner() and c:IsCanBeSynchroMaterial(syncard,tuner) and c:IsSetCard(0xeff) and (f==nil or f(c))
end
function c9991000.syntg(e,syncard,f,minc,maxc)
	local c=e:GetHandler()
	local lv=syncard:GetLevel()-c:GetLevel()
	if lv<=0 then return false end
	local g=Duel.GetMatchingGroup(c9991000.synfilter,syncard:GetControler(),LOCATION_MZONE,LOCATION_MZONE,c,syncard,c,f)
	local res=g:CheckWithSumEqual(Card.GetSynchroLevel,lv,minc,maxc,syncard)
	return res
end
function c9991000.synop(e,tp,eg,ep,ev,re,r,rp,syncard,f,minc,maxc)
	local c=e:GetHandler()
	local lv=syncard:GetLevel()-c:GetLevel()
	local g=Duel.GetMatchingGroup(c9991000.synfilter,syncard:GetControler(),LOCATION_MZONE,LOCATION_MZONE,c,syncard,c,f)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
	local sg=g:SelectWithSumEqual(tp,Card.GetSynchroLevel,lv,minc,maxc,syncard)
	Duel.SetSynchroMaterial(sg)
end
function c9991000.pufilter(c)
	return c:IsFaceup() and c:IsSetCard(0xeff)
end
function c9991000.putg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c9991000.pufilter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c9991000.pufilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c9991000.pufilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
end
function c9991000.puop(e,tp,eg,ep,ev,re,r,rp)
	local val=Duel.GetFirstTarget():GetAttack()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e1:SetValue(val/2)
	e:GetHandler():RegisterEffect(e1)
end
