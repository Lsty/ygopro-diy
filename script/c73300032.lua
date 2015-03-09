--恶魔领主 蕾米莉亚·斯卡雷特
function c73300032.initial_effect(c)
	c:SetUniqueOnField(1,0,73300032)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c73300032.ffilter,c73300032.ffilter1,true)
	--adjust
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(c73300032.adjustop)
	c:RegisterEffect(e2)
	--spsummon condition
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	e3:SetValue(c73300032.splimit)
	c:RegisterEffect(e3)
	--cannot summon,spsummon,flipsummon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,1)
	e4:SetTarget(c73300032.sumlimit)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_CANNOT_SUMMON)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTargetRange(1,1)
	e5:SetTarget(c73300032.sumlimit)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetTargetRange(1,1)
	e6:SetTarget(c73300032.sumlimit)
	c:RegisterEffect(e6)
	--cannot summon,spsummon,flipsummon
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e8:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e8:SetTargetRange(1,1)
	e8:SetTarget(c73300032.sumlimit1)
	c:RegisterEffect(e8)
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCode(EFFECT_CANNOT_SUMMON)
	e9:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e9:SetTargetRange(1,1)
	e9:SetTarget(c73300032.sumlimit1)
	c:RegisterEffect(e9)
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_FIELD)
	e10:SetRange(LOCATION_MZONE)
	e10:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	e10:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e10:SetTargetRange(1,1)
	e10:SetTarget(c73300032.sumlimit1)
	c:RegisterEffect(e10)
	--special summon
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e11:SetCode(EVENT_LEAVE_FIELD)
	e11:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e11:SetCondition(c73300032.spcon)
	e11:SetTarget(c73300032.sptg)
	e11:SetOperation(c73300032.spop)
	c:RegisterEffect(e11)
end
c73300032[0]=0
c73300032[1]=0
c73300032[2]=0
c73300032[3]=0
c73300032[99]=0
function c73300032.ffilter(c)
	return c:IsType(TYPE_SYNCHRO) and c:IsAttribute(ATTRIBUTE_DARK)
end
function c73300032.ffilter1(c)
	return c:IsType(TYPE_XYZ) and c:IsRace(RACE_FIEND)
end
function c73300032.rmfilter(c,rc)
	return not c:IsRace(0xffffff-rc)
end
function c73300032.rmfilter2(c,rc)
	return c:IsRace(0xffffff-rc)
end
function c73300032.getrace(g)
	local arc=0
	local tc=g:GetFirst()
	while tc do
		arc=bit.bor(arc,tc:GetRace())
		tc=g:GetNext()
	end
	return arc
end
function c73300032.getattribute(g)
	local aat=0
	local tc=g:GetFirst()
	while tc do
		aat=bit.bor(aat,tc:GetAttribute())
		tc=g:GetNext()
	end
	return aat
end
function c73300032.rmfilter1(c,at)
	return not c:IsAttribute(0xff-at)
end
function c73300032.rmfilter3(c,at)
	return c:IsAttribute(0xff-at)
end
function c73300032.adjustop(e,tp,eg,ep,ev,re,r,rp)
	if c73300032[99]==1 then return end
	local phase=Duel.GetCurrentPhase()
	if (phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or phase==PHASE_DAMAGE_CAL then return end
	c73300032[99]=1
	local g1=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	local g2=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local g3=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	local g4=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local c=e:GetHandler()
	if g1:GetCount()==0 then c73300032[tp]=0
	else
		local rac=c73300032.getrace(g1)
		if bit.band(rac,rac-1)~=0 then
			if c73300032[tp]==0 or bit.band(c73300032[tp],rac)==0 then
				Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(73300032,0))
				rac=Duel.AnnounceRace(tp,1,rac)
			else rac=c73300032[tp] end
		end
		g1:Remove(c73300032.rmfilter,nil,rac)
		g3:Remove(c73300032.rmfilter2,nil,rac)
		c73300032[tp]=rac
	end
	if g2:GetCount()==0 then c73300032[1-tp]=0
	else
		local rac=c73300032.getrace(g2)
		if bit.band(rac,rac-1)~=0 then
			if c73300032[1-tp]==0 or bit.band(c73300032[1-tp],rac)==0 then
				Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(73300032,0))
				rac=Duel.AnnounceRace(1-tp,1,rac)
			else rac=c73300032[1-tp] end
		end
		g2:Remove(c73300032.rmfilter,nil,rac)
		g4:Remove(c73300032.rmfilter3,nil,rac)
		c73300032[1-tp]=rac
	end
	if g3:GetCount()==0 then c73300032[tp+2]=0
	else
		local att=c73300032.getattribute(g3)
		if bit.band(att,att-1)~=0 then
			if c73300032[tp+2]==0 or bit.band(c73300032[tp+2],att)==0 then
				Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(73300032,1))
				att=Duel.AnnounceAttribute(tp,1,att)
			else att=c73300032[tp+2] end
		end
		g3:Remove(c73300032.rmfilter1,nil,att)
		c73300032[tp+2]=att
	end
	if g4:GetCount()==0 then c73300032[1-tp+2]=0
	else
		local att=c73300032.getattribute(g4)
		if bit.band(att,att-1)~=0 then
			if c73300032[1-tp+2]==0 or bit.band(c73300032[1-tp+2],att)==0 then
				Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(73300032,1))
				att=Duel.AnnounceAttribute(1-tp,1,att)
			else att=c73300032[1-tp+2] end
		end
		g4:Remove(c73300032.rmfilter1,nil,att)
		c73300032[1-tp+2]=att
	end
	g1:Merge(g2)
	g1:Merge(g3)
	g1:Merge(g4)
	if g1:GetCount()>0 then
		Duel.SendtoGrave(g1,REASON_EFFECT)
		Duel.Readjust()
	end
	c73300032[99]=0
end
function c73300032.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c73300032.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	if sumpos and bit.band(sumpos,POS_FACEDOWN)>0 then return false end
	local rc=c73300032[sump]
	if targetp then rc=c73300032[targetp] end
	if rc==0 then return false end
	return c:IsRace(0xffffff-rc)
end
function c73300032.sumlimit1(e,c,sump,sumtype,sumpos,targetp)
	if sumpos and bit.band(sumpos,POS_FACEDOWN)>0 then return false end
	local at=c73300032[sump+2]
	if targetp then at=c73300032[targetp+2] end
	if at==0 then return false end
	return c:IsAttribute(0xff-at)
end
function c73300032.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and c:GetLocation()~=LOCATION_DECK
end
function c73300032.filter(c,e,tp)
	return c:IsSetCard(0x734) and c:IsType(TYPE_SPELL) and c:IsSSetable()
end
function c73300032.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c73300032.filter(chkc) end
	if chk==0 then
		return Duel.IsExistingTarget(c73300032.filter,tp,LOCATION_GRAVE,0,1,nil)
			and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local sg=Duel.SelectTarget(tp,c73300032.filter,tp,LOCATION_GRAVE,0,1,1,nil)
end
function c73300032.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if g:GetCount()~=1 then return end
	Duel.SSet(tp,g)
	Duel.ConfirmCards(1-tp,g)
end