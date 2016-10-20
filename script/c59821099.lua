--Idol Master of Disgrace and Agony Mutated Muse
function c59821099.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsCode,59821007),aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_WATER),true)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c59821099.splimit)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c59821099.atkuptg)
	e2:SetValue(600)
	c:RegisterEffect(e2)
	--place pcard
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(59821099,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c59821099.pencon)
	e3:SetTarget(c59821099.pentg)
	e3:SetOperation(c59821099.penop)
	c:RegisterEffect(e3)
	--immune spell
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c59821099.efilter)
	c:RegisterEffect(e4)
	--to pzone
	local e5=Effect.CreateEffect(c)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetCondition(c59821099.con)
	e5:SetOperation(c59821099.op)
	c:RegisterEffect(e5)
	--damage
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_CHAINING)
	e6:SetRange(LOCATION_PZONE)
	e6:SetCondition(c59821099.regcon)
	e6:SetOperation(c59821099.regop)
	c:RegisterEffect(e6)
	--atk gain
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(59821099,1))
	e7:SetCategory(CATEGORY_ATKCHANGE)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e7:SetCode(EVENT_BATTLE_DESTROYING)
	e7:SetCondition(c59821099.condition)
	e7:SetOperation(c59821099.operation)
	c:RegisterEffect(e7)
	--all out
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_ATTACK_ALL)
	e8:SetValue(c59821099.atkallfilter)
	c:RegisterEffect(e8)
end
function c59821099.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c59821099.atkuptg(e,c)
	return c:IsSetCard(0xa1a2)
end
function c59821099.penfilter4(c)
    return c:IsSetCard(0xa1a2)
end
function c59821099.pencon(e,tp,eg,ep,ev,re,r,rp)
    local seq=e:GetHandler():GetSequence()
	return Duel.GetFieldCard(tp,LOCATION_SZONE,13-seq)==nil 
end
function c59821099.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c59821099.penfilter4,tp,LOCATION_EXTRA,0,1,nil) end
end
function c59821099.penop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c59821099.penfilter4,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then 
	    local tc=g:GetFirst()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c59821099.efilter(e,te)
	return e:GetHandlerPlayer()~=te:GetHandlerPlayer() and te:IsActiveType(TYPE_SPELL)
end
function c59821099.penfilter1(c)
    return c:IsDestructable() and c:GetSequence()==6
end
function c59821099.penfilter2(c)
    return c:IsDestructable() and c:GetSequence()==7
end
function c59821099.con(e,tp,eg,ep,ev,re,r,rp)
    local p1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local p2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
    if not p1 and not p2 then return false end 
    return (e:GetHandler():IsReason(REASON_EFFECT) or e:GetHandler():IsReason(REASON_BATTLE)) and
	    (p1 and p1:IsDestructable()) or (p2 and p2:IsDestructable()) and e:GetHandler():GetPreviousLocation()==LOCATION_MZONE
end
function c59821099.op(e,tp,eg,ep,ev,re,r,rp)
    local p1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local p2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	local g1=nil
	local g2=nil
	if p1 then 
	    g1=Duel.GetMatchingGroup(c59821099.penfilter1,tp,LOCATION_SZONE,0,nil)
	end
	if p2 then 
	    g2=Duel.GetMatchingGroup(c59821099.penfilter2,tp,LOCATION_SZONE,0,nil)
		if g1 then 
		    g1:Merge(g2)
		else 
		    g1=g2
		end
	end
	if g1 and Duel.Destroy(g1,REASON_EFFECT)~=0 then 
	        local c=e:GetHandler()	
	        Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end 
end
function c59821099.filter(c)
	return c:IsFaceup() and c:IsLocation(LOCATION_ONFIELD) and c:IsSetCard(0xa1a2)
end
function c59821099.regcon(e,tp,eg,ep,ev,re,r,rp)
	if not re or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(c59821099.filter,1,nil) and tp~=rp
end
function c59821099.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetRange(LOCATION_SZONE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetLabelObject(re)
	e1:SetReset(RESET_EVENT+0x1fc0000+RESET_CHAIN)
	e1:SetCondition(c59821099.damcon)
	e1:SetOperation(c59821099.damop)
	c:RegisterEffect(e1)
end
function c59821099.damcon(e,tp,eg,ep,ev,re,r,rp)
	return re==e:GetLabelObject()
end
function c59821099.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,59821099)
	Duel.Damage(1-tp,500,REASON_EFFECT)
end
function c59821099.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsFaceup() and e:GetHandler():IsRelateToBattle()
end
function c59821099.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToBattle() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(200)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e1)
	end
end
function c59821099.atkallfilter(e,c)
	return bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL
end