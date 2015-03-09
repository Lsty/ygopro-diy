--万圣夜的魔之娘
function c24094676.initial_effect(c)
	--pendulum summon
	aux.AddPendulumProcedure(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,24094676)
	e2:SetCondition(c24094676.con)
	e2:SetOperation(c24094676.spop)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetTarget(c24094676.rettg)
	e3:SetOperation(c24094676.retop)
	c:RegisterEffect(e3)
end
function c24094676.confilter(c,e,tp,lscale,rscale)
	local lv=c:GetLevel()
	return (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsType(TYPE_PENDULUM)
		and lv>lscale and lv<rscale and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_PENDULUM,tp,false,false)
end
function c24094676.con(e)
	local c=e:GetHandler()
	local tp=c:GetControler()
	local lpz=c
	local rpz=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	if c:GetSequence()~=6 then 
		lpz=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
		rpz=c end
	if lpz==nil or rpz==nil then return false end
	local lscale=lpz:GetLeftScale()
	local rscale=rpz:GetRightScale()
	if lscale>rscale then lscale,rscale=rscale,lscale end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return false
	else return Duel.IsExistingMatchingCard(c24094676.confilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,nil,e,tp,lscale,rscale)
	end
end
function c24094676.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lpz=c
	local rpz=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	if c:GetSequence()~=6 then 
		lpz=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
		rpz=c end
	if not c:IsFaceup() or not c:IsRelateToEffect(e) or lpz==nil or rpz==nil then return false end
	local lscale=lpz:GetLeftScale()
	local rscale=rpz:GetRightScale()
	if lscale>rscale then lscale,rscale=rscale,lscale end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return false end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c24094676.confilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,ft,nil,e,tp,lscale,rscale)
	local pg=Group.FromCards(lpz,rpz)
	Duel.HintSelection(pg)
	Duel.SpecialSummon(sg,SUMMON_TYPE_PENDULUM,tp,tp,false,false,POS_FACEUP)
end
function c24094676.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c24094676.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end