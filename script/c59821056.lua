--Idol Master of Shine and Cheerfulness Shinjou Hinaki
function c59821056.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsCode,59821061),aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_EARTH),true)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c59821056.splimit)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c59821056.atkuptg)
	e2:SetValue(600)
	c:RegisterEffect(e2)
	--actlimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCondition(c59821056.actcon)
	e3:SetOperation(c59821056.actop)
	c:RegisterEffect(e3)
	--place pcard
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(59821056,0))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c59821056.pencon)
	e4:SetTarget(c59821056.pentg)
	e4:SetOperation(c59821056.penop)
	c:RegisterEffect(e4)
	--immune spell
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(c59821056.efilter)
	c:RegisterEffect(e5)
	--flip
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(59821056,1))
	e6:SetCategory(CATEGORY_POSITION+CATEGORY_DESTROY)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_BATTLE_DESTROYING)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetCondition(c59821056.flipcon)
	e6:SetTarget(c59821056.fliptg)
	e6:SetOperation(c59821056.flipop)
	c:RegisterEffect(e6)
	--to pzone
	local e7=Effect.CreateEffect(c)
	e7:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e7:SetCategory(CATEGORY_DESTROY)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_DESTROYED)
	e7:SetCondition(c59821056.con)
	e7:SetOperation(c59821056.op)
	c:RegisterEffect(e7)
	--atk up
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(59821056,2))
	e8:SetCategory(CATEGORY_ATKCHANGE)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e8:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetCondition(c59821056.atkcon)
	e8:SetTarget(c59821056.atktg)
	e8:SetOperation(c59821056.atkop)
	c:RegisterEffect(e8)
end
function c59821056.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c59821056.atkuptg(e,c)
	return c:IsSetCard(0xa1a2)
end
function c59821056.actcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	if tc:IsControler(1-tp) then tc=Duel.GetAttackTarget() end
	return tc and tc:IsControler(tp) and tc:IsSetCard(0xa1a2)
end
function c59821056.actop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c59821056.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e1,tp)
end
function c59821056.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_TRAP+TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c59821056.penfilter4(c)
    return c:IsSetCard(0xa1a2)
end
function c59821056.pencon(e,tp,eg,ep,ev,re,r,rp)
    local seq=e:GetHandler():GetSequence()
	return Duel.GetFieldCard(tp,LOCATION_SZONE,13-seq)==nil 
end
function c59821056.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c59821056.penfilter4,tp,LOCATION_EXTRA,0,1,nil) end
end
function c59821056.penop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c59821056.penfilter4,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then 
	    local tc=g:GetFirst()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c59821056.efilter(e,te)
	return e:GetHandlerPlayer()~=te:GetHandlerPlayer() and te:IsActiveType(TYPE_SPELL)
end
function c59821056.flipcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsRelateToBattle() and c:GetBattleTarget():IsType(TYPE_MONSTER)
end
function c59821056.flipfilter(c)
	return c:IsFacedown()
end
function c59821056.fliptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c59821056.flipfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c59821056.flipfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c59821056.flipfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c59821056.flipop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFacedown() then
		Duel.ChangePosition(tc,0,POS_FACEUP_ATTACK,0,POS_FACEUP_DEFENSE)
		if tc:IsAttackBelow(1500) then
			Duel.BreakEffect()
			Duel.Destroy(tc,REASON_EFFECT)
		else
			Duel.ConfirmCards(1-tc:GetControler(),tc)
			Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
		end
	end
end
function c59821056.penfilter1(c)
    return c:IsDestructable() and c:GetSequence()==6
end
function c59821056.penfilter2(c)
    return c:IsDestructable() and c:GetSequence()==7
end
function c59821056.con(e,tp,eg,ep,ev,re,r,rp)
    local p1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local p2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
    if not p1 and not p2 then return false end 
    return (e:GetHandler():IsReason(REASON_EFFECT) or e:GetHandler():IsReason(REASON_BATTLE)) and
	    (p1 and p1:IsDestructable()) or (p2 and p2:IsDestructable()) and e:GetHandler():GetPreviousLocation()==LOCATION_MZONE
end
function c59821056.op(e,tp,eg,ep,ev,re,r,rp)
    local p1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local p2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	local g1=nil
	local g2=nil
	if p1 then 
	    g1=Duel.GetMatchingGroup(c59821056.penfilter1,tp,LOCATION_SZONE,0,nil)
	end
	if p2 then 
	    g2=Duel.GetMatchingGroup(c59821056.penfilter2,tp,LOCATION_SZONE,0,nil)
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
function c59821056.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c59821056.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,g,g:GetCount(),0,0)
end
function c59821056.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsImmuneToEffect(e) then
		local atk=tc:GetAttack()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(atk/2)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		if c:IsRelateToEffect(e) and c:IsFaceup() then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetValue(atk/2)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			c:RegisterEffect(e2)
		end
	end
end
