--Legendary Wyrm Xiang
function c77777832.initial_effect(c)
    --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetDescription(aux.Stringid(77777832,0))
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Psummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_ADJUST)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(0,LOCATION_PZONE)
	e2:SetOperation(c77777832.psactivate)
	c:RegisterEffect(e2)
	--opponent splimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetTargetRange(0,1)
	e3:SetCondition(c77777832.psopcon)
	e3:SetTarget(c77777832.psoplimit)
	c:RegisterEffect(e3)
	--Self Destroy
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetDescription(aux.Stringid(77777832,1))
	e4:SetOperation(c77777832.selfDes)
	c:RegisterEffect(e4)
	--special summon
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_SPSUMMON_PROC)
	e5:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e5:SetRange(LOCATION_HAND)
	e5:SetCondition(c77777832.spcon)
	c:RegisterEffect(e5)
	--Activate
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_PZONE)
	e6:SetDescription(aux.Stringid(77777832,2))
	e6:SetCountLimit(1,77777832)
	e6:SetTarget(c77777832.target)
	e6:SetOperation(c77777832.activate)
	c:RegisterEffect(e6)
end

--If both cards in your PZ are Reverse Pendulums, then your opponent's PS is limited.
--0xb00 == reverse pendulum set code
function c77777832.psopcon(e,c)
	local tp=e:GetHandler()
	return Duel.GetFieldCard(tp,LOCATION_SZONE,6):IsSetCard(0xb00) and Duel.GetFieldCard(tp,LOCATION_SZONE,7):IsSetCard(0xb00)
end
function c77777832.psoplimit(e,c,sump,sumtype,sumpos,targetp)
	local lsc=Duel.GetFieldCard(tp,LOCATION_SZONE,6):GetLeftScale()
	local rsc=Duel.GetFieldCard(tp,LOCATION_SZONE,7):GetRightScale()
	if rsc>lsc then
		return (c:GetLevel()>lsc and c:GetLevel()<rsc) and bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
	else
		return (c:GetLevel()>rsc and c:GetLevel()<lsc) and bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
	end
end

function c77777832.psactivate(e,tp,eg,ep,ev,re,r,rp)
	local tc1=Duel.GetFieldCard(1-tp,LOCATION_SZONE,6)
	if tc1 and tc1:GetFlagEffect(77777831)<1 then
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC_G)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_BOTH_SIDE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,10000000)
	e1:SetCondition(c77777832.pendcon)
	e1:SetOperation(c77777832.pendop)
	e1:SetValue(SUMMON_TYPE_PENDULUM)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	tc1:RegisterEffect(e1)
	tc1:RegisterFlagEffect(77777831,RESET_EVENT+0x1fe0000,0,1)
	end
end
function c77777832.spfilter(c)
return c:IsFaceup() and c:IsSetCard(0xb00)
end
function c77777832.pendcon(e,c,og)
	if c==nil then return true end
	local tp=e:GetOwnerPlayer()
	local rpz=Duel.GetFieldCard(1-tp,LOCATION_SZONE,7)
	if rpz==nil then return false end
	if c:IsSetCard(0xb00) or rpz:IsSetCard(0xb00) then return false end
	local lscale=c:GetLeftScale()
	local rscale=rpz:GetRightScale()
	if lscale>rscale then lscale,rscale=rscale,lscale end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return false end
	if og then
	return og:IsExists(aux.PConditionFilter,1,nil,e,tp,lscale,rscale)
	and Duel.GetFieldCard(tp,LOCATION_SZONE,6):IsSetCard(0xb00) and Duel.GetFieldCard(tp,LOCATION_SZONE,7):IsSetCard(0xb00)
	else
	return Duel.IsExistingMatchingCard(aux.PConditionFilter,tp,LOCATION_EXTRA+LOCATION_HAND,0,1,nil,e,tp,lscale,rscale)
	and Duel.GetFieldCard(tp,LOCATION_SZONE,6):IsSetCard(0xb00) and Duel.GetFieldCard(tp,LOCATION_SZONE,7):IsSetCard(0xb00)
	end
end
function c77777832.pendop(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
	local rpz=Duel.GetFieldCard(1-tp,LOCATION_SZONE,7)
	local lscale=c:GetLeftScale()
	local rscale=rpz:GetRightScale()
	if lscale>rscale then lscale,rscale=rscale,lscale end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if og then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=og:FilterSelect(tp,aux.PConditionFilter,1,ft,nil,e,tp,lscale,rscale)
	sg:Merge(g)
	else
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.PConditionFilter,tp,LOCATION_EXTRA+LOCATION_HAND,0,1,ft,nil,e,tp,lscale,rscale)
	sg:Merge(g)
	end
end 

function c77777832.selfDes(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Destroy(e:GetHandler(),REASON_RULE)
end

function c77777832.cfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_WYRM)
end
function c77777832.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c77777832.cfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end

function c77777832.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xb00) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function c77777832.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77777832.filter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
end
function c77777832.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c77777832.filter,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end