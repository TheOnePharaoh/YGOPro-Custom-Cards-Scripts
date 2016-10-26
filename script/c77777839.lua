--Legendary Wyrm Terramor
function c77777839.initial_effect(c)
    --fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x409),aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_EARTH),1,1,true)
	--indestructable by card effects
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--Psummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_ADJUST)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(0,LOCATION_PZONE)
	e2:SetOperation(c77777839.psactivate)
	c:RegisterEffect(e2)
	--opponent splimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetTargetRange(0,1)
	e3:SetCondition(c77777839.psopcon)
	e3:SetTarget(c77777839.psoplimit)
	c:RegisterEffect(e3)
	--Self Destroy
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetDescription(aux.Stringid(77777839,1))
	e4:SetOperation(c77777839.selfDes)
	c:RegisterEffect(e4)
	--SS on fusion summon	
 	local e5=Effect.CreateEffect(c)
 	e5:SetDescription(aux.Stringid(8706701,1))
 	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
 	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetRange(LOCATION_PZONE)
	e5:SetCondition(c77777839.sshcon)
	e5:SetOperation(c77777839.sshop)
	c:RegisterEffect(e5)
	--Place opponent's card in Pzone
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_PZONE)
	e6:SetDescription(aux.Stringid(77777839,2))
	e6:SetCondition(c77777839.placecon)
	e6:SetOperation(c77777839.placeop)
	c:RegisterEffect(e6)
	--Place this card in PZone
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(77777839,0))
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1)
	e7:SetCondition(c77777839.pcon)
	e7:SetOperation(c77777839.pop)
	c:RegisterEffect(e7)
	--attack all
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_ATTACK_ALL)
	e8:SetValue(1)
	c:RegisterEffect(e8)
	--Set opponent's card
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_QUICK_O+EFFECT_TYPE_FIELD)
	e9:SetDescription(aux.Stringid(77777839,4))
	e9:SetCategory(CATEGORY_POSITION)
	e9:SetCode(EVENT_ATTACK_ANNOUNCE)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCondition(c77777839.con)
	e9:SetOperation(c77777839.op)
	c:RegisterEffect(e9)
end

--If both cards in your PZ are Reverse Pendulums, then your opponent's PS is limited.
--0xb00 == reverse pendulum set code
function c77777839.psopcon(e,c)
	local tp=e:GetHandler()
	return Duel.GetFieldCard(tp,LOCATION_SZONE,6):IsSetCard(0xb00) and Duel.GetFieldCard(tp,LOCATION_SZONE,7):IsSetCard(0xb00)
end
function c77777839.psoplimit(e,c,sump,sumtype,sumpos,targetp)
	local lsc=Duel.GetFieldCard(tp,LOCATION_SZONE,6):GetLeftScale()
	local rsc=Duel.GetFieldCard(tp,LOCATION_SZONE,7):GetRightScale()
	if rsc>lsc then
		return (c:GetLevel()>lsc and c:GetLevel()<rsc) and bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
	else
		return (c:GetLevel()>rsc and c:GetLevel()<lsc) and bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
	end
end

function c77777839.psactivate(e,tp,eg,ep,ev,re,r,rp)
	local tc1=Duel.GetFieldCard(1-tp,LOCATION_SZONE,6)
	if tc1 and tc1:GetFlagEffect(77777839)<1 then
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC_G)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_BOTH_SIDE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,10000000)
	e1:SetCondition(c77777839.pendcon)
	e1:SetOperation(c77777839.pendop)
	e1:SetValue(SUMMON_TYPE_PENDULUM)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	tc1:RegisterEffect(e1)
	tc1:RegisterFlagEffect(77777839,RESET_EVENT+0x1fe0000,0,1)
	end
end
function c77777839.spfilter(c)
return c:IsFaceup() and c:IsSetCard(0xb00)
end
function c77777839.pendcon(e,c,og)
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
function c77777839.pendop(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
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

function c77777839.selfDes(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Destroy(e:GetHandler(),REASON_RULE)
end

function c77777839.pcon(e,tp,eg,ep,ev,re,r,rp)
	return not (Duel.GetFieldCard(tp,LOCATION_SZONE,6) and Duel.GetFieldCard(tp,LOCATION_SZONE,7))
end
function c77777839.pop(e,tp,eg,ep,ev,re,r,rp)
	if (Duel.GetFieldCard(tp,LOCATION_SZONE,6) and Duel.GetFieldCard(tp,LOCATION_SZONE,7)) then return end
	Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
end


function c77777839.sshfilter(c,tp)
  return c:IsControler(tp) and bit.band(c:GetSummonType(),SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c77777839.sshcon(e,tp,eg,ep,ev,re,r,rp)
  if not eg then return false end
  return eg:IsExists(c77777839.sshfilter,1,nil,tp)
end
function c77777839.sshop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
end


function c77777839.placecon(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetFieldCard(1-tp,LOCATION_SZONE,6)==nil or Duel.GetFieldCard(1-tp,LOCATION_SZONE,7)==nil)
		and Duel.IsExistingMatchingCard(c77777839.penfilter,tp,0,LOCATION_DECK,1,nil)
end

function c77777839.placeop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local sg=Duel.GetMatchingGroup(c77777839.penfilter,tp,0,LOCATION_DECK,nil)
	Duel.ConfirmCards(tp,sg)
	local g=sg:Select(tp,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.MoveToField(tc,1-tp,1-tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end

function c77777839.penfilter(c)
	return c:IsType(TYPE_PENDULUM) and not c:IsSetCard(0xb00) and not c:IsForbidden()
end

function c77777839.con(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return a==e:GetHandler() and d and d:IsCanTurnSet()
end
function c77777839.op(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if not a:IsRelateToBattle() or a:IsFacedown() or not d:IsRelateToBattle() or d:IsFacedown() then return end
	if a:IsControler(1-tp) then a,d=d,a end
	if Duel.ChangePosition(d,POS_FACEDOWN_DEFENSE)~=0 then
		local og=Duel.GetOperatedGroup()
		local tc=og:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
			tc=og:GetNext()
		end
		Duel.NegateAttack()
	end
end