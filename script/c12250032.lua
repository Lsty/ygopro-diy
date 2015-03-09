--Gosick·智慧之泉
function c12250032.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsType,TYPE_SYNCHRO),aux.NonTuner(Card.IsType,TYPE_SYNCHRO),2)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c12250032.sptg)
	e3:SetOperation(c12250032.spop)
	c:RegisterEffect(e3)
	--destroy & damage
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_RELEASE+CATEGORY_DAMAGE)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e5:SetCode(EVENT_MSET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(c12250032.con)
	e5:SetCost(c12250032.setcost)
	e5:SetTarget(c12250032.settg)
	e5:SetOperation(c12250032.setop)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_SSET)
	c:RegisterEffect(e6)
	local e7=e5:Clone()
	e7:SetCode(EVENT_CHANGE_POS)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e8)
end
function c12250032.filter(c,e,tp)
	return c:IsSetCard(0x4c9) and c:IsType(TYPE_SYNCHRO+TYPE_XYZ)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c12250032.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c12250032.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c12250032.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c12250032.tfilter(c,e,tp)
	return (c:IsSSetable() and (c:IsType(TYPE_SPELL+TYPE_TRAP) or c:IsSetCard(0x598) or c:IsCode(9791914) or c:IsCode(58132856))) or (c:IsMSetable(true,nil) and c:IsType(TYPE_MONSTER))
end
function c12250032.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CANNOT_TRIGGER)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_SET_ATTACK)
		e3:SetValue(3300)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e3)
		local m=0
		if not Duel.IsPlayerAffectedByEffect(1-e:GetHandler():GetControler(),EFFECT_CANNOT_MSET) and not Duel.IsPlayerAffectedByEffect(1-e:GetHandler():GetControler(),EFFECT_CANNOT_SSET) then
			if Duel.GetMatchingGroupCount(c12250032.tfilter,1-tp,LOCATION_HAND,0,nil,e,1-tp)>0 and Duel.SelectYesNo(1-tp,aux.Stringid(12250003,0)) then
				m=1
				local sc=Group.GetFirst(Duel.SelectMatchingCard(1-tp,c12250032.tfilter,1-tp,LOCATION_HAND,0,1,1,nil,e,1-tp))
				if sc:IsType(TYPE_SPELL+TYPE_TRAP) then
					Duel.SSet(1-tp,sc)
				elseif (sc:IsSetCard(0x598) or sc:IsCode(9791914) or sc:IsCode(58132856)) and Duel.SelectYesNo(1-tp,aux.Stringid(12250003,1)) then
					Duel.SSet(1-tp,sc)
				else
					Duel.MSet(1-tp,sc,true,nil)
				end
			end
		end
		if m==1 and c:IsRelateToEffect(e) and c:IsFaceup() then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(-1000)
			e1:SetReset(RESET_EVENT+0x1ff0000)
			tc:RegisterEffect(e1)
		end
		Duel.SpecialSummonComplete()
	end
end
function c12250032.con(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp
end
function c12250032.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(12250032)==0 end
	e:GetHandler():RegisterFlagEffect(12250032,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c12250032.sfilter(c,e,tp)
	return c:IsSetCard(0x4c9) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c12250032.setfilter(c,e)
	return c:IsFacedown() and c:IsLocation(LOCATION_ONFIELD)
end
function c12250032.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c12250032.setfilter,1,nil,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and Duel.CheckReleaseGroup(tp,nil,1,nil,e,tp) and Duel.IsExistingMatchingCard(c12250032.sfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetTargetCard(eg)
end
function c12250032.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=-1 or not Duel.CheckReleaseGroup(tp,nil,1,nil,e,tp) or not Duel.IsExistingMatchingCard(c12250032.sfilter,tp,LOCATION_DECK,0,1,nil,e,tp) then return end
	if not eg:IsExists(c12250032.setfilter,1,nil,nil) then return end
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
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local rg=Duel.SelectReleaseGroup(tp,nil,1,1,nil,e,tp)
		if rg:GetCount()>0 then
			Duel.Release(rg,REASON_EFFECT)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,c12250032.sfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
			if g:GetCount()>0 then
				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end