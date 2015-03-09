--Gosick·安普罗兹
function c12250017.initial_effect(c)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_HAND)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCost(c12250017.spcost)
	e3:SetTarget(c12250017.sptg)
	e3:SetOperation(c12250017.spop)
	c:RegisterEffect(e3)
	--destroy & damage
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e5:SetCode(EVENT_MSET)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCountLimit(1)
	e5:SetCondition(c12250017.con)
	e5:SetCost(c12250017.setcost)
	e5:SetTarget(c12250017.settg)
	e5:SetOperation(c12250017.setop)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_SSET)
	c:RegisterEffect(e6)
	local e7=e5:Clone()
	e7:SetCode(EVENT_CHANGE_POS)
	c:RegisterEffect(e7)
	local e8=e5:Clone()
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e8)
end
function c12250017.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,12250017)==0
		and e:GetHandler():IsDiscardable() and e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
	Duel.RegisterFlagEffect(tp,12250017,RESET_PHASE+PHASE_END,0,1)
end
function c12250017.spfilter(c,e,tp)
	return c:GetLevel()==4 and c:IsSetCard(0x4c9) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c12250017.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c12250017.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c12250017.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c12250017.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c12250017.tfilter(c,e,tp)
	return (c:IsSSetable() and (c:IsType(TYPE_SPELL+TYPE_TRAP) or c:IsSetCard(0x598) or c:IsCode(9791914) or c:IsCode(58132856))) or (c:IsMSetable(true,nil) and c:IsType(TYPE_MONSTER))
end
function c12250017.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsChainDisablable(0) and not Duel.IsPlayerAffectedByEffect(1-e:GetHandler():GetControler(),EFFECT_CANNOT_MSET) and not Duel.IsPlayerAffectedByEffect(1-e:GetHandler():GetControler(),EFFECT_CANNOT_SSET) then
		if Duel.GetMatchingGroupCount(c12250017.tfilter,1-tp,LOCATION_HAND,0,nil,e,1-tp)>0 and Duel.SelectYesNo(1-tp,aux.Stringid(12250003,0)) then
			local sc=Group.GetFirst(Duel.SelectMatchingCard(1-tp,c12250017.tfilter,1-tp,LOCATION_HAND,0,1,1,nil,e,1-tp))
			if sc:IsType(TYPE_SPELL+TYPE_TRAP) then
				Duel.SSet(1-tp,sc)
			elseif (sc:IsSetCard(0x598) or sc:IsCode(9791914) or sc:IsCode(58132856)) and Duel.SelectYesNo(1-tp,aux.Stringid(12250003,1)) then
				Duel.SSet(1-tp,sc)
			else
				Duel.MSet(1-tp,sc,true,nil)
			end
			return
		end
	end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c12250017.con(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp
end
function c12250017.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,12250017)==0 end
	Duel.RegisterFlagEffect(tp,12250017,RESET_PHASE+PHASE_END,0,1)
end
function c12250017.filter(c,e,tp)
	return c:GetLevel()==4 and c:IsType(TYPE_TUNER) and c:IsAbleToRemove()
		and Duel.IsExistingMatchingCard(c12250017.exfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
end
function c12250017.exfilter(c,e,tp)
	return c:IsSetCard(0x4c9) and c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c12250017.setfilter(c,e)
	return c:IsFacedown() and c:IsLocation(LOCATION_ONFIELD)
end
function c12250017.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c12250017.setfilter,1,nil,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0	and Duel.IsExistingTarget(c12250017.filter,tp,LOCATION_GRAVE,0,1,e:GetHandler(),e,tp) end
	Duel.SetTargetCard(eg)
end
function c12250017.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not Duel.IsExistingTarget(c12250017.filter,tp,LOCATION_GRAVE,0,1,e:GetHandler(),e,tp) then return end
	if not eg:IsExists(c12250017.setfilter,1,nil,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	local res=Duel.SelectOption(tp,70,71,72)
	local sc=eg:GetFirst()
	local mg=Group.CreateGroup()
	local m=0
	while sc do
		if sc:IsLocation(LOCATION_ONFIELD) and sc:IsRelateToEffect(e) and sc:IsFacedown() then
			mg:AddCard(sc)
			if (res==0 and sc:IsType(TYPE_MONSTER)) or (res==1 and sc:IsType(TYPE_SPELL)) or (res==2 and sc:IsType(TYPE_TRAP)) then m=m+1 end
		end
		sc=eg:GetNext()
	end
	Duel.ConfirmCards(tp,mg)
	if m~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local tc=Duel.SelectMatchingCard(tp,c12250017.filter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler(),e,tp):GetFirst()
		local rg=Group.FromCards(e:GetHandler(),tc)
		if Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)==2 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=Duel.SelectMatchingCard(tp,c12250017.exfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
			local spc=sg:GetFirst()
			if spc and Duel.SpecialSummonStep(spc,0,tp,tp,false,false,POS_FACEUP) then
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_CANNOT_TRIGGER)
				e2:SetReset(RESET_EVENT+0x1fe0000)
				spc:RegisterEffect(e2)
				Duel.SpecialSummonComplete()
			end
		end
	end
end