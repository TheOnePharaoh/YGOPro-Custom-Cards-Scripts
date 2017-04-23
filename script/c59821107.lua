--Samuel, The Divine Order
function c59821107.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,6,3,c59821107.ovfilter,aux.Stringid(59821107,0),2,c59821107.xyzop)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--atk down
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(-200)
	c:RegisterEffect(e1)
	--place pcard
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(59821107,3))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,59821107)
	e2:SetCondition(c59821107.pencon)
	e2:SetTarget(c59821107.pentg)
	e2:SetOperation(c59821107.penop)
	c:RegisterEffect(e2)
	--to pzone
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCondition(c59821107.con)
	e3:SetOperation(c59821107.op)
	c:RegisterEffect(e3)
	--immune spell
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c59821107.imcon)
	e4:SetValue(c59821107.efilter)
	c:RegisterEffect(e4)
	--indes
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e6)
	--atk
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EFFECT_UPDATE_ATTACK)
	e7:SetValue(c59821107.atkupvalue)
	c:RegisterEffect(e7)
	--special summon token
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(59821107,1))
	e8:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e8:SetCode(EVENT_BATTLE_DESTROYING)
	e8:SetProperty(0,EFFECT_FLAG2_XMDETACH)
	e8:SetCondition(c59821107.tokcon)
	e8:SetCost(c59821107.tokcost)
	e8:SetTarget(c59821107.toktg)
	e8:SetOperation(c59821107.tokop)
	c:RegisterEffect(e8)
	--destroy
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(59821107,2))
	e9:SetCategory(CATEGORY_DESTROY)
	e9:SetType(EFFECT_TYPE_IGNITION)
	e9:SetRange(LOCATION_PZONE)
	e9:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e9:SetCountLimit(1,59821107)
	e9:SetTarget(c59821107.destrotg)
	e9:SetOperation(c59821107.destroop)
	c:RegisterEffect(e9)
end
function c59821107.xyzopfilter(c)
	return c:IsSetCard(0xa1a2) and c:IsType(TYPE_PENDULUM) and c:IsAbleToGraveAsCost()
end
function c59821107.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xa1a2) and c:GetRank()==5
end
function c59821107.xyzop(e,tp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c59821107.xyzopfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c59821107.xyzopfilter,1,1,REASON_COST,nil)
	e:GetHandler():RegisterFlagEffect(59821107,RESET_EVENT+0xfe0000+RESET_PHASE+PHASE_END,0,1)
end
function c59821107.penfilter4(c)
    return c:IsSetCard(0xa1a2)
end
function c59821107.pencon(e,tp,eg,ep,ev,re,r,rp)
    local seq=e:GetHandler():GetSequence()
	return Duel.GetFieldCard(tp,LOCATION_SZONE,13-seq)==nil 
end
function c59821107.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c59821107.penfilter4,tp,LOCATION_EXTRA,0,1,nil) end
end
function c59821107.penop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c59821107.penfilter4,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then 
	    local tc=g:GetFirst()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c59821107.imcon(e)
	return e:GetHandler():GetOverlayCount()>0
end
function c59821107.efilter(e,te)
	return e:GetHandlerPlayer()~=te:GetHandlerPlayer() and te:IsActiveType(TYPE_SPELL)
end
function c59821107.penfilter1(c)
    return c:IsDestructable() and c:GetSequence()==6
end
function c59821107.penfilter2(c)
    return c:IsDestructable() and c:GetSequence()==7
end
function c59821107.con(e,tp,eg,ep,ev,re,r,rp)
    local p1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local p2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
    if not p1 and not p2 then return false end 
    return (e:GetHandler():IsReason(REASON_EFFECT) or e:GetHandler():IsReason(REASON_BATTLE)) and
	    (p1 and p1:IsDestructable()) or (p2 and p2:IsDestructable()) and e:GetHandler():GetPreviousLocation()==LOCATION_MZONE
end
function c59821107.op(e,tp,eg,ep,ev,re,r,rp)
    local p1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local p2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	local g1=nil
	local g2=nil
	if p1 then 
	    g1=Duel.GetMatchingGroup(c59821107.penfilter1,tp,LOCATION_SZONE,0,nil)
	end
	if p2 then 
	    g2=Duel.GetMatchingGroup(c59821107.penfilter2,tp,LOCATION_SZONE,0,nil)
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
function c59821107.atkfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0xa1a2)
end
function c59821107.atkupvalue(e,c)
	return Duel.GetMatchingGroupCount(c59821107.atkfilter,c:GetControler(),LOCATION_MZONE,LOCATION_MZONE,nil)*1000
end
function c59821107.tokcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsRelateToBattle() and c:GetBattleTarget():IsType(TYPE_MONSTER)
end
function c59821107.tokcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c59821107.toktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c59821107.tokop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE)<=0 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,59821108,0,0x4011,2000,1200,4,RACE_FAIRY,ATTRIBUTE_LIGHT,POS_FACEUP_ATTACK,1-tp) then return end
	local token=Duel.CreateToken(tp,59821108)
	if Duel.SpecialSummonStep(token,0,tp,1-tp,false,false,POS_FACEUP_ATTACK) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_DESTROYED)
		e1:SetLabelObject(token)
		e1:SetCondition(c59821107.damcon)
		e1:SetOperation(c59821107.damop)
		Duel.RegisterEffect(e1,tp)
	end
	Duel.SpecialSummonComplete()
end
function c59821107.damcon(e,tp,eg,ep,ev,re,r,rp)
	local tok=e:GetLabelObject()
	if eg:IsContains(tok) then
		return true
	else
		if not tok:IsLocation(LOCATION_MZONE) then e:Reset() end
		return false
	end
end
function c59821107.damop(e,tp,eg,ep,ev,re,r,rp)
	local tok=e:GetLabelObject()
	Duel.Damage(tok:GetPreviousControler(),800,REASON_EFFECT)
end
function c59821107.destrofilter(c)
	return c:IsFaceup() and c:IsSetCard(0xa1a2) and c:IsDestructable()
end
function c59821107.destrotg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c59821107.destrofilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler())
		and Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,c59821107.destrofilter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,2,0,0)
end
function c59821107.destroop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end