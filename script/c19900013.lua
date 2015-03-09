--目隐团·空想世界·小樱茉莉
function c19900013.initial_effect(c)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetRange(LOCATION_DECK)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c19900013.descon)
	e2:SetTarget(c19900013.destg)
	e2:SetValue(1)
	e2:SetOperation(c19900013.desop)
	c:RegisterEffect(e2)
end
function c19900013.descon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetReason(),0x41)==0x41
end
function c19900013.synfilter1(c,e,tp,f)
	return c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0x199) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
end
function c19900013.synfilter2(c,syncard,tuner,f)
	return c:IsNotTuner() and c:IsCanBeSynchroMaterial(syncard,tuner) and c:IsAbleToRemove() and (f==nil or f(c))
end
function c19900013.destg(e,tp,eg,ep,ev,re,r,rp,chk,f,minc,maxc)
	local c=e:GetHandler()
	local exg=Duel.GetMatchingGroup(c19900013.synfilter1,tp,LOCATION_EXTRA,0,nil,e,tp,f)
	local g=exg:GetFirst()
	local tg=Group.CreateGroup()
	while g do
		local exg1=Duel.GetMatchingGroup(c19900013.synfilter2,g:GetControler(),LOCATION_GRAVE,0,c,g,c,f)
		local lv=g:GetLevel()-c:GetLevel()
		if exg1:CheckWithSumEqual(Card.GetSynchroLevel,lv,minc,maxc,g)==true then
			tg:AddCard(g)
		end
		g=exg:GetNext()
	end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsAbleToRemove() and tg~=nil end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c19900013.desop(e,tp,eg,ep,ev,re,r,rp,f,minc,maxc)
	local c=e:GetHandler()
	local exg=Duel.GetMatchingGroup(c19900013.synfilter1,tp,LOCATION_EXTRA,0,nil,e,tp,f)
	local g=exg:GetFirst()
	local tg=Group.CreateGroup()
	while g do
		local exg1=Duel.GetMatchingGroup(c19900013.synfilter2,g:GetControler(),LOCATION_GRAVE,0,c,g,c,f)
		local lv=g:GetLevel()-c:GetLevel()
		if exg1:CheckWithSumEqual(Card.GetSynchroLevel,lv,minc,maxc,g)==true then
			tg:AddCard(g)
		end
		g=exg:GetNext()
	end
	if tg==nil or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not c:IsAbleToRemove() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg2=tg:Select(tp,1,1,nil)
	local sg=sg2:GetFirst()
	local exg1=Duel.GetMatchingGroup(c19900013.synfilter2,tp,LOCATION_GRAVE,0,c,sg,c,f)
	local lv=sg:GetLevel()-c:GetLevel()
	local sg1=exg1:SelectWithSumEqual(tp,Card.GetSynchroLevel,lv,minc,maxc,sg)
	sg1:AddCard(c)
	Duel.SetSynchroMaterial(sg1)
	Duel.Remove(sg1,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_SYNCHRO)
	Duel.BreakEffect()
	Duel.SpecialSummon(sg,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
	sg:CompleteProcedure()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(-500)
	sg:RegisterEffect(e1)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_DEFENCE)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	e2:SetValue(-500)
	sg:RegisterEffect(e2)
end