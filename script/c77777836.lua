--Legendary Wyrm Ryujin
function c77777836.initial_effect(c)
	c:EnableReviveLimit()
    --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetDescription(aux.Stringid(77777836,0))
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Psummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_ADJUST)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(0,LOCATION_PZONE)
	e2:SetOperation(c77777836.psactivate)
	c:RegisterEffect(e2)
	--opponent splimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetTargetRange(0,1)
	e3:SetCondition(c77777836.psopcon)
	e3:SetTarget(c77777836.psoplimit)
	c:RegisterEffect(e3)
	--Self Destroy
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetDescription(aux.Stringid(77777836,1))
	e4:SetOperation(c77777836.selfDes)
	c:RegisterEffect(e4)
	--special summon condition
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e5)
	--special summon
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_SPSUMMON_PROC)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e6:SetRange(LOCATION_HAND+LOCATION_EXTRA)
	e6:SetCondition(c77777836.spcon)
	e6:SetOperation(c77777836.spop)
	c:RegisterEffect(e6)
	--Send to grave
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(77777836,2))
	e7:SetCategory(CATEGORY_TOGRAVE)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e7:SetTarget(c77777836.tgtg)
	e7:SetOperation(c77777836.tgop)
	c:RegisterEffect(e7)
	--Unaffected by Opponent Card Effects
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCode(EFFECT_IMMUNE_EFFECT)
	e8:SetValue(c77777836.unval)
	c:RegisterEffect(e8)
	--Indes
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e9:SetRange(LOCATION_PZONE)
	e9:SetValue(c77777836.tgvalue)
	c:RegisterEffect(e9)
	--Place in PZONE
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_IGNITION)
	e10:SetRange(LOCATION_PZONE)
	e10:SetCountLimit(1,77777836)
	e10:SetDescription(aux.Stringid(77777836,3))
	e10:SetOperation(c77777836.placeop)
	c:RegisterEffect(e10)
end

--If both cards in your PZ are Reverse Pendulums, then your opponent's PS is limited.
--0xb00 == reverse pendulum set code
function c77777836.psopcon(e,c)
	local tp=e:GetHandler()
	return Duel.GetFieldCard(tp,LOCATION_SZONE,6):IsSetCard(0xb00) and Duel.GetFieldCard(tp,LOCATION_SZONE,7):IsSetCard(0xb00)
end
function c77777836.psoplimit(e,c,sump,sumtype,sumpos,targetp)
	local lsc=Duel.GetFieldCard(tp,LOCATION_SZONE,6):GetLeftScale()
	local rsc=Duel.GetFieldCard(tp,LOCATION_SZONE,7):GetRightScale()
	if rsc>lsc then
		return (c:GetLevel()>lsc and c:GetLevel()<rsc) and bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
	else
		return (c:GetLevel()>rsc and c:GetLevel()<lsc) and bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
	end
end

function c77777836.psactivate(e,tp,eg,ep,ev,re,r,rp)
	local tc1=Duel.GetFieldCard(1-tp,LOCATION_SZONE,6)
	if tc1 and tc1:GetFlagEffect(77777831)<1 then
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC_G)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_BOTH_SIDE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,10000000)
	e1:SetCondition(c77777836.pendcon)
	e1:SetOperation(c77777836.pendop)
	e1:SetValue(SUMMON_TYPE_PENDULUM)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	tc1:RegisterEffect(e1)
	tc1:RegisterFlagEffect(77777831,RESET_EVENT+0x1fe0000,0,1)
	end
end
function c77777836.spfilter(c)
return c:IsFaceup() and c:IsSetCard(0xb00)
end
function c77777836.pendcon(e,c,og)
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
function c77777836.pendop(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
--	Duel.Hint(HINT_CARD,0,31531170)
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

function c77777836.selfDes(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Destroy(e:GetHandler(),REASON_RULE)
end

function c77777836.unval(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end

function c77777836.spcfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_WYRM) and c:IsDestructable()
end
function c77777836.spcfilter2(c)
	return c:IsFaceup() and c:IsSetCard(0x409) and c:IsAbleToRemoveAsCost()
end
function c77777836.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c77777836.spcfilter,tp,LOCATION_MZONE,LOCATION_MZONE,2,nil)
		and Duel.IsExistingMatchingCard(c77777836.spcfilter2,tp,LOCATION_EXTRA,0,2,e:GetHandler())
		and (Duel.GetLocationCount(tp,LOCATION_MZONE)+Duel.GetMatchingGroupCount(c77777836.spcfilter,tp,LOCATION_MZONE,0,nil))>0
end
function c77777836.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then
		local g=Duel.SelectMatchingCard(tp,c77777836.spcfilter,tp,LOCATION_MZONE,0,1,1,nil)
		local g2=Duel.SelectMatchingCard(tp,c77777836.spcfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g3=Duel.SelectMatchingCard(tp,c77777836.spcfilter2,tp,LOCATION_EXTRA,0,2,2,e:GetHandler())
		g:Merge(g2)
		Duel.Destroy(g,REASON_COST)
		Duel.Remove(g3,POS_FACEUP,REASON_COST)
	else
		local g4=Duel.SelectMatchingCard(tp,c77777836.spcfilter,tp,LOCATION_MZONE,LOCATION_MZONE,2,2,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g3=Duel.SelectMatchingCard(tp,c77777836.spcfilter2,tp,LOCATION_EXTRA,0,2,2,e:GetHandler())
		Duel.Destroy(g4,REASON_COST)
		Duel.Remove(g3,POS_FACEUP,REASON_COST)
	end
end

function c77777836.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,0)
end
function c77777836.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SendtoGrave(tc,REASON_EFFECT)
end


function c77777836.tgvalue(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end

function c77777836.desfilter(c)
	return (c:GetSequence()==6 or c:GetSequence()==7) and c:IsDestructable()
end
function c77777836.placeop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c77777836.desfilter,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
	local count=g:GetCount()
	if Duel.Destroy(g,REASON_EFFECT)==count and Duel.GetFieldCard(1-tp,LOCATION_SZONE,6)==nil 
	  and Duel.GetFieldCard(1-tp,LOCATION_SZONE,7)==nil and Duel.IsExistingMatchingCard(c77777836.penfilter,tp,0,LOCATION_DECK,2,nil)then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local sg=Duel.GetMatchingGroup(c77777836.penfilter,tp,0,LOCATION_DECK,nil)
		Duel.ConfirmCards(tp,sg)
		local g=sg:Select(tp,2,2,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.MoveToField(tc,1-tp,1-tp,LOCATION_SZONE,POS_FACEUP,true)
		end
		tc=g:GetNext()
		if tc then
			Duel.MoveToField(tc,1-tp,1-tp,LOCATION_SZONE,POS_FACEUP,true)
		end
	end
end

function c77777836.penfilter(c)
	return c:IsType(TYPE_PENDULUM) and not c:IsSetCard(0xb00) and not c:IsForbidden()
end